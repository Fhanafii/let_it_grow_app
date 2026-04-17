import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../plant/viewmodel/plant_viewmodel.dart'; // Sesuaikan path

class InstallationGuideScreen extends StatefulWidget {
  const InstallationGuideScreen({super.key});

  @override
  State<InstallationGuideScreen> createState() => _InstallationGuideScreenState();
}

// 2. BAGIAN STATE (Kode yang kamu tulis sebelumnya)
class _InstallationGuideScreenState extends State<InstallationGuideScreen> {
  @override
  void initState() {
    super.initState();
    
    // Gunakan Microtask agar listener tidak bentrok saat proses render
    Future.microtask(() {
      final plantVM = context.read<PlantViewModel>();
      plantVM.addListener(_handleError);
      plantVM.fetchExistingCredentials();
    });
  }

  void _handleError() {
    // Pastikan widget masih terpasang di tree sebelum panggil context
    if (!mounted) return;
    
    final plantVM = context.read<PlantViewModel>();
    if (plantVM.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(plantVM.errorMessage!),
          backgroundColor: const Color(0xFFD91A1A), // Pakai warna merah brand
        ),
      );
      plantVM.errorMessage = null; 
    }
  }

  @override
  void dispose() {
    // Menghapus listener sangat penting agar tidak memory leak
    // Kita gunakan try-catch untuk jaga-jaga jika provider sudah di-dispose duluan
    try {
      context.read<PlantViewModel>().removeListener(_handleError);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A910A);
    final plantVM = context.watch<PlantViewModel>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Troubleshooting Koneksi",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStep(
              "1. Restart Perangkat",
              "Jika perangkat gagal terhubung ke internet, tekan tombol **RST (Reset)** pada modul Wemos satu kali. Tunggu 10 detik hingga lampu indikator kembali berkedip.",
            ),
            _buildStep(
              "2. Masuk ke Mode Konfigurasi",
              "Jika ingin mengubah WiFi, pastikan HP terhubung ke jaringan WiFi perangkat: **'Smart-Plant-Setup'**. Buka browser dan akses **192.168.4.1**.",
            ),
            _buildStep(
              "3. Cek Status Kredensial",
              "Gunakan data di bawah ini jika kamu diminta memasukkan MQTT Username dan Password pada halaman konfigurasi perangkat.",
            ),

            // Section MQTT Fields (Statis)
            const Text("Mqtt User", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 8),
            _buildReadOnlyTextField(plantVM.mqttUser ?? "Memuat..."), // Nantinya bisa diambil dari Provider/Data

            const SizedBox(height: 16),

            const Text("Mqtt Password", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 8),
            _buildReadOnlyTextField(plantVM.mqttPass ?? "Memuat..."),

            const SizedBox(height: 25),

            _buildStep(
              "4. Update Data & Simpan",
              "Pilih menu **'Configure WiFi'**, masukkan Nama & Password WiFi rumahmu yang baru, serta pastikan Data MQTT di atas sudah benar. Klik **'Save'**.",
            ),

            // Alert Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD91A1A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFD91A1A)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Jangan bagikan kredensial MQTT ini kepada siapapun demi keamanan perangkatmu.",
                      style: TextStyle(fontSize: 13, color: Color(0xFFD91A1A)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A910A)),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyTextField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0A910A)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.black54, fontFamily: 'monospace')),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 20, color: Color(0xFF0A910A)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
            },
          ),
        ],
      ),
    );
  }
}
