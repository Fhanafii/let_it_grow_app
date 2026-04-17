import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../plant/viewmodel/plant_viewmodel.dart';
import '../widgets/delete_device_sheet.dart';

class DeviceInfoScreen extends StatefulWidget {
  const DeviceInfoScreen({super.key});

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final plantVM = context.read<PlantViewModel>();
      plantVM.addListener(_handleError); // Tambahkan listener error
      plantVM.fetchExistingCredentials();
    });
  }

  void _handleError() {
    if (!mounted) return;
    final plantVM = context.read<PlantViewModel>();
    if (plantVM.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(plantVM.errorMessage!), backgroundColor: const Color(0xFFD91A1A)),
      );
      plantVM.errorMessage = null; 
    }
  }

  void _showDeletePopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Agar rounded corner terlihat
      builder: (context) => DeleteDeviceSheet(
        onDelete: () {
          Navigator.pop(context); // Tutup popup
          // Panggil fungsi reset di ViewModel nanti di sini
        },
      ),
    );
  }

  @override
  void dispose() {
    try {
      context.read<PlantViewModel>().removeListener(_handleError);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A910A);
    const dangerColor = Color(0xFFD91A1A); // Merah sesuai gambar
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
          "Informasi Perangkat",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false, // Sesuai gambar, judul agak ke kiri
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field MQTT User
            const Text("Mqtt User", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 8),
            _buildReadOnlyTextField(plantVM.mqttUser ?? "Memuat..."),

            const SizedBox(height: 24),

            // Field MQTT Password
            const Text("Mqtt Password", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: 8),
            _buildReadOnlyTextField(plantVM.mqttPass ?? "Memuat..."),

            const SizedBox(height: 40),

            // Tombol Reset Perangkat
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // OnPressed dikosongkan sesuai permintaan
                  _showDeletePopup(); // Tampilkan popup konfirmasi
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: dangerColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Reset Perangkat",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
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
            child: Text(
              text,
              style: const TextStyle(color: Colors.black54, fontFamily: 'monospace'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_outlined, size: 20, color: Color(0xFF0A910A)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Berhasil disalin"), duration: Duration(seconds: 1)),
              );
            },
          ),
        ],
      ),
    );
  }
}
