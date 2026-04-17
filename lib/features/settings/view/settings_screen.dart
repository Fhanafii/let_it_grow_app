import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'installation_guide_screen.dart';
import 'device_info_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A910A);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1), // Background hijau pucat
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Halaman
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),

              // List Menu Settings
              _buildSettingItem(
                icon: SvgPicture.asset('assets/ic_perangkat.svg', height: 19, ),
                title: "Informasi Perangkat",
                onTap: () {
                  // Navigasi ke info perangkat
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeviceInfoScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSettingItem(
                icon: SvgPicture.asset('assets/ic_book.svg', height: 21,),
                title: "Panduan Troubleshooting perangkat",
                onTap: () {
                  // Navigasi ke setup_guide_screen
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InstallationGuideScreen()),
                  );
                },
              ),

              const Spacer(), // Dorong tombol logout ke bawah

              // Tombol Logout
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Masih kosong sesuai permintaan
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Versi Aplikasi
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Versi 1.0",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              const SizedBox(height: 10), // Sesuaikan height ini untuk menaikan versi aplikasi dan logout button
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Baris Menu
  Widget _buildSettingItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0A910A).withOpacity(0.5)),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0A910A),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF0A910A)),
          ],
        ),
      ),
    );
  }
}
