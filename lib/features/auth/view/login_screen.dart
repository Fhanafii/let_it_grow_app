import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Jangan lupa install provider
import '../viewmodel/auth_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Spacer(), // Dorong konten ke tengah
            // Logo dan Teks Branding
            SvgPicture.asset('assets/logo.svg', height: 120),
            const SizedBox(height: 16),
            // const Text(
            //   "Let it Grow",
            //   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
            // ),
            // const Text("Grow with your plants, every day", style: TextStyle(color: Colors.grey)),
            
            const Spacer(), // Dorong tombol ke bawah

            // Tombol Login (Full Width & Hijau)
            SizedBox(
              width: double.infinity,
              height: 59,
              child: ElevatedButton.icon(
                icon: SvgPicture.asset('assets/google_logo.svg', height: 24), // Logo Google di kiri
                label: const Text('Sign in with Google', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: Colors.white)),
                onPressed: () => authVM.login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0A910A), // Warna hijau sesuai gambar
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
