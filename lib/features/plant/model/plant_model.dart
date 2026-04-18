class MoistureData {
  final int id;
  final DateTime createdAt;
  final String deviceId;
  final int rawValue;

  MoistureData({
    required this.id,
    required this.createdAt,
    required this.deviceId,
    required this.rawValue,
  });

  // Logika Konversi Raw ke Persentase di dalam Model
  double get percentage {
    int dryValue = 1024; 
    int wetValue = 7;
    double calc = ((dryValue - rawValue) / (dryValue - wetValue)) * 100;
    return calc.clamp(0, 100);
  }

   // Fungsi untuk cek status online (threshold 10 menit)
  bool get isStillOnline {
    final now = DateTime.now();
    final difference = now.difference(createdAt).inMinutes;
    return difference < 10;
  }
  
  // Mapper dari JSON Supabase ke Object Dart
  factory MoistureData.fromJson(Map<String, dynamic> json) {
    return MoistureData(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      deviceId: json['device_id'],
      rawValue: json['moisture_value'],
    );
  }
}
