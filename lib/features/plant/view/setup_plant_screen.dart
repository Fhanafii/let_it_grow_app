import 'package:flutter/material.dart';
import 'setup_guide_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SetupPlantScreen extends StatelessWidget {
  const SetupPlantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Ilustrasi
              SvgPicture.asset('assets/connect_plant.svg', height: 80,
              ),
              const SizedBox(height: 24),

              //Teks Deskripsi
              const Text(
                "Kamu Belum ada tanaman yang terhubung nih",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF0A910A),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                
              ),
              const SizedBox(height: 32),

              // Tombol hubungkan Tanaman
              SizedBox(
                width: 147,
                height: 38,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const SetupGuideScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A910A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Hubungkan Tanaman",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 7, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                  ),
                  ),
                ),
            ],
          ),
        ),
        ),
    );
  }
}
