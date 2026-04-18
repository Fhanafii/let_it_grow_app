import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:let_it_grow_app/features/plant/view/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../viewmodel/plant_viewmodel.dart';

class SetupGuideScreen extends StatefulWidget {
  const SetupGuideScreen({super.key});

  @override
  State<SetupGuideScreen> createState() => _SetupGuideScreenState();
}

class _SetupGuideScreenState extends State<SetupGuideScreen> {
  @override
  void initState() {
    super.initState();
    final plantVM = context.read<PlantViewModel>();
    
    // Listen status koneksi dan error
    plantVM.addListener(_onViewModelUpdate);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      plantVM.listenToFirstConnection(); // screen atau widgets akan terblock jika device belum terkonfigurasi setelah berhasil akan dapat popup dan bisa lanjut ke home screen
    });
  }

  void _onViewModelUpdate() {
    final plantVM = context.read<PlantViewModel>();

    // 1. Tangani Error (Munculkan SnackBar)
    if (plantVM.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(plantVM.errorMessage!)),
      );
      // Reset error agar tidak muncul berulang kali
      plantVM.errorMessage = null; 
    }

    // 2. Tangani Koneksi Berhasil (Munculkan Custom Popup)
    if (plantVM.isDeviceConnected) {
      _showCustomSuccessPopup();
    }
  }

  void _showCustomSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // User harus menekan tombol untuk keluar
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Agar dialog tidak memenuhi layar
            children: [
              // 1. Gambar Logo Tanaman (Ganti dengan asset kamu)
              SvgPicture.asset(
                'assets/plant_popup.svg', // Gunakan file logo yang sama
                height: 76,
              ),
              const SizedBox(height: 24),

              // 2. Teks Selamat (Sesuai Gambar)
              const Text(
                "Selamat! Tanamanmu kini sudah terhubung.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0A910A), // Warna hijau tema
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 32),

              // 3. Tombol Navigasi ke Home
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog dulu
                    context.read<PlantViewModel>().goToHome(context); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A910A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Setup Selesai",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Jangan lupa hapus listener agar tidak memory leak
    context.read<PlantViewModel>().removeListener(_onViewModelUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantVM = context.watch<PlantViewModel>();

    const primaryColor = Color(0xFF0A910A);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Panduan Pemasangan Perangkat",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildStep(
                      "1. Nyalakan Perangkat",
                      "Hubungkan perangkat Wemos ke sumber daya (Adaptor/USB). Tunggu sekitar 10 detik hingga lampu indikator berkedip.",
                    ),
                    _buildStep(
                      "2. Hubungkan ke WiFi Perangkat",
                      "Buka pengaturan WiFi di HP kamu. Cari dan hubungkan ke jaringan bernama: 'Smart-Plant-Setup'. Jika muncul notifikasi 'WiFi tidak memiliki akses internet', pilih 'Tetap Terhubung'.",
                    ),
                    _buildStep(
                      "3. Buka Konfigurasi",
                      "Biasanya halaman pengaturan akan muncul otomatis. Jika tidak, buka browser (Chrome/Safari) dan ketik alamat: 192.168.4.1.",
                    ),
                    _buildStep(
                      "4. Siapkan Kredensial",
                      "Klik tombol 'Generate Mqtt account' di bawah ini untuk mendapatkan identitas unik perangkatmu.",
                    ),

                    // Section MQTT Input Fields
                    const Text("Mqtt User", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 8),
                    _buildReadOnlyTextField(plantVM.mqttUser ?? "Belum di-generate"),
                    
                    const SizedBox(height: 16),
                    
                    const Text("Mqtt Password", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 8),
                    _buildReadOnlyTextField(plantVM.mqttPass ?? "Belum di-generate"),

                    const SizedBox(height: 20),
                    
                    // Button Generate
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: plantVM.isGenerating 
                          ? null // Disable tombol jika sedang loading
                          : () => plantVM.generateCredentials(), 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: plantVM.isGenerating 
                          ? const SizedBox(
                              height: 20, 
                              width: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Text("Generate Mqtt account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildStep(
                      "5. Masukkan Data Jaringan & MQTT",
                      "• Pilih menu 'Configure WiFi'.\n• Pilih Nama WiFi Rumah kamu dan masukkan Password WiFi-nya.\n• Pada kolom di bawahnya, masukkan MQTT Username dan MQTT Password yang kamu dapatkan di Langkah 4.\n• Klik 'Save'.",
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
        ),
        if(plantVM.isNavigatingToHome) const LoadingScreen(),
      ],
    );   
  }

  // Widget Helper untuk Judul dan Deskripsi Step
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

  // Widget Helper untuk Field MQTT dengan tombol Copy
  Widget _buildReadOnlyTextField(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF0A910A)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.black54)),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 20, color: Color(0xFF0A910A)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              // Opsional: Tambahkan Toast/Snackbar 'Copied'
            },
          ),
        ],
      ),
    );
  }
}
