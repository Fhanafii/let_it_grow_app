// lib/data/repositories/plant_repository.dart
import 'package:let_it_grow_app/features/plant/viewmodel/plant_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/plant/model/mqtt_account_model.dart';
import '../../features/plant/model/plant_model.dart';

class PlantRepository {
  final _supabase = Supabase.instance.client;

  // Memanggil RPC untuk generate akun MQTT
   Future<MqttAccount> generateMqttAccount() async {
    // final response = await _supabase.rpc('generate_mqtt_credentials');
    // return response as Map<String, dynamic>;
    final List<dynamic> response  = await _supabase.rpc('generate_mqtt_credentials');

    if(response.isNotEmpty) {
      return MqttAccount.fromJson(response[0] as Map<String, dynamic>);
    }else {
      throw Exception('Gagal mendapatkan data akun');
    }
  }

  // Memanggil register mqtt credentials untuk troubleshooting user
  Future<MqttAccount?> getRegisteredCredentials() async  {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null){
      throw Exception("Akses ditolak: Silakan login dengan Google terlebih dahulu.");
    }

    try {
      final response = await _supabase
          .from('device_auth')
          .select('mqtt_username, mqtt_password_hash')
          .eq('user_id', userId)
          .maybeSingle();
      
      return response != null ? MqttAccount.fromJson(response) : null;
    } catch (e) {
      rethrow;
    }
  }
  // Khusus untuk menampilkan data di chart
   Stream<List<Map<String, dynamic>>> getMoistureHistoryStream(
    String userId, {
    ChartFilter filter = ChartFilter.today,
  }) {
    // 1. Tentukan waktu mulai berdasarkan filter
    DateTime startDate;
    if (filter == ChartFilter.month) {
      startDate = DateTime.now().subtract(const Duration(days: 30));
    } else {
      startDate = DateTime.now().subtract(const Duration(hours: 24));
    }

    // 2. Lakukan stream dengan filter waktu (gte = Greater Than or Equal)
    return _supabase
        .from('moisture_logs')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: true)
        .limit(filter == ChartFilter.month ? 100 : 20); // Sesuaikan limit jika bulanan
  }

  // Mendapatkan data sensor terbaru (Realtime) untuk mengetahui apakah device user telah terkoneksi dan akan diarahkan langsung ke home screen jika berhasil
  Stream<List<Map<String, dynamic>>> getMoistureStream(String userId) {
    return _supabase
        .from('moisture_logs')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1); // Hanya ambil 1 data terbaru
  }
}
