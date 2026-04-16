// lib/features/plant/viewmodel/plant_viewmodel.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../../data/repositories/plant_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantViewModel extends ChangeNotifier {
  final PlantRepository _plantRepository = PlantRepository();
  StreamSubscription? _moistureSubscription;

  String? mqttUser;
  String? mqttPass;
  bool isDeviceConnected = false;
  bool isGenerating = false;
  String? errorMessage;
  bool isNavigatingToHome = false;


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
      final creds = await _plantRepository.generateMqttAccount();
      mqttUser = creds['username'];
      mqttPass = creds['password'];
      errorMessage = null; // Bersihkan error jika berhasil
    } catch (e) {
      debugPrint("Error generate credentials: $e");
    } finally {
      isGenerating = false;
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
