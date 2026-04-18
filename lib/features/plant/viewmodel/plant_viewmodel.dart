// lib/features/plant/viewmodel/plant_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/repositories/plant_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import '../model/plant_model.dart';
import '../model/weather_model.dart';
import '../../../core/api/weather_service.dart';
import 'package:geolocator/geolocator.dart';

enum ChartFilter { today, month }

class PlantViewModel extends ChangeNotifier {
  final PlantRepository _plantRepository = PlantRepository();
  final _supabase = Supabase.instance.client;

  StreamSubscription? _moistureSubscription;

  String? mqttUser;
  String? mqttPass;
  bool isDeviceConnected = false;
  bool isGenerating = false;
  String? errorMessage;
  bool isNavigatingToHome = false;

  ChartFilter _activeFilter = ChartFilter.today;
  ChartFilter get activeFilter => _activeFilter;
  // Open Weather
  final WeatherService _weatherService = WeatherService();
  WeatherData? currentWeatherData;
  // double _currentTemp = 0.0;
  // double get currentTemp => _currentTemp;

  void setFilter(ChartFilter filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  String get userName {
    // Ambil display_name dari metadata Google User
    final user = _supabase.auth.currentUser;
    return user?.userMetadata?['full_name'] ?? "User";
  }

  // Fungsi untuk ambil suhu (panggil saat init dashboard atau refresh)
  Future<void> updateWeatherWithLocation() async {
    try {
      // 1. Cek & Minta Izin Lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // 2. Ambil Koordinat
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          distanceFilter: 100,
        ),
      );

      // 3. Panggil Service
      currentWeatherData = await _weatherService.fetchWeather(
        position.latitude, 
        position.longitude
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Lokasi Error: $e");
    }
  }

  // Stream untuk Card (hanya ambil 1 data terbaru untuk efisiensi)
  Stream<MoistureData?> getLatestMoistureStream() {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return Stream.value(null);

    return _plantRepository.getMoistureStream(userId).map((dataList) {
      if (dataList.isEmpty) return null;
      return MoistureData.fromJson(dataList.first);
    });
  }

  Stream<List<MoistureData>> getMoistureHistoryStream() {
    final userId = _supabase.auth.currentUser?.id;

    if(userId == null){
      return Stream.value([]);
    }

      return _plantRepository
        .getMoistureHistoryStream(userId, filter: _activeFilter)
        .map((dataList) {
      // dataList di sini sudah berupa List<MoistureData> karena sudah di-map di Repository
      List<MoistureData> allData = dataList.map((json) => MoistureData.fromJson(json)).toList();

      DateTime now = DateTime.now();
      DateTime threshold = _activeFilter == ChartFilter.month 
          ? now.subtract(const Duration(days: 30)) 
          : now.subtract(const Duration(hours: 24));

      // PERBAIKAN: Kembalikan data yang difilter manual berdasarkan waktu
      return allData.where((data) => data.createdAt.isAfter(threshold)).toList();
    });
  }

  // Fungsi helper untuk konversi ke FlSpot agar Chart Widget mengerti
  List<FlSpot> mapToSpots(List<MoistureData> data) {
      return data.asMap().entries.map((e) {
        return FlSpot(e.key.toDouble(), e.value.rawValue.toDouble());
      }).toList();
  }

  String formatTime(double value, List<MoistureData> data) {
    int index = value.toInt();
    if (index >= 0 && index < data.length) {
      DateTime time = data[index].createdAt;
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    }
    return "";
  }

  Future<void> goToHome(BuildContext context) async {
    isNavigatingToHome = true;
    notifyListeners();

    // Beri Jeda sedikit agar transisi terlihat smooth
    await Future.delayed(const Duration(seconds: 2));

    if(context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    }

    // Reset state setelah navigasi
    isNavigatingToHome = false;
    notifyListeners();
  }

  // Fungsi Generate Kredensial
  Future<void> generateCredentials() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      errorMessage = "Akses ditolak: Silakan login dengan Google terlebih dahulu.";
      notifyListeners();
      return; 
    } 

    isGenerating = true;
    notifyListeners();

   try {
      final account = await _plantRepository.generateMqttAccount();
      mqttUser = account.username;
      mqttPass = account.password;
    } catch (e) {
      debugPrint("Error generate credentials: $e");
    } finally {
      isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> fetchExistingCredentials() async {
    // Hanya fetch jika variabel masih kosong agar tidak boros API call
    if (mqttUser != null && mqttPass != null) return;

    try {
      final account = await _plantRepository.getRegisteredCredentials();
      if (account != null) {
        mqttUser = account.username;
        mqttPass = account.password;
        notifyListeners();
      }else{
        errorMessage = "Anda belum memiliki akun MQTT. Silakan lakukan setup.";
        notifyListeners();
      }
    } catch (e) {
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Fungsi Listen Koneksi Pertama (Realtime)
  void listenToFirstConnection() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null){
      errorMessage = "Sesi berakhir, silahkan login kembali";
      notifyListeners();
      return;
    }

    // Batalkan subscription lama jika ada
    _moistureSubscription?.cancel();

    _moistureSubscription = _plantRepository.getMoistureStream(userId).listen((data) {
      if (data.isNotEmpty && !isDeviceConnected) {
        isDeviceConnected = true;
        notifyListeners();
        // Hentikan stream setelah berhasil konek untuk hemat limit Supabase
        _moistureSubscription?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _moistureSubscription?.cancel(); // Sangat penting untuk cegah leak
    super.dispose();
  }
}
