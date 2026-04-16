// lib/data/repositories/plant_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantRepository {
  final _supabase = Supabase.instance.client;

  // Memanggil RPC untuk generate akun MQTT
  Future<Map<String, dynamic>> generateMqttAccount() async {
    // final response = await _supabase.rpc('generate_mqtt_credentials');
    // return response as Map<String, dynamic>;
    final List<dynamic> response  = await _supabase.rpc('generate_mqtt_credentials');

    if(response.isNotEmpty) {
      return response[0] as Map<String, dynamic>;
    }else {
      throw Exception('Gagal mendapatkan data akun');
    }
  }

  // Mendapatkan data sensor terbaru (Realtime)
  Stream<List<Map<String, dynamic>>> getMoistureStream(String userId) {
    return _supabase
        .from('moisture_logs')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(1); // Hanya ambil 1 data terbaru
  }
}
