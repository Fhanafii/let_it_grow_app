import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_bottom_nav_painter.dart'; // Import painter hasil konversi tadi
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_bottom_nav_painter.dart'; // Import painter hasil konversi tadi

class CustomBottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const activeColor = Color(0xFF0A910A);

    return SizedBox(
      width: screenWidth,
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Putih Melengkung
          CustomPaint(
            size: Size(screenWidth, 100),
            painter: RPSCustomPainter(), 
          ),

          // Baris Ikon
          Positioned(
            bottom: 15, // Jarak dari bawah layar agar ikon masuk ke bar putih
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem('assets/ic_chart.svg', 0),
                  _buildNavItem('assets/ic_gear.svg', 2),
                ],
              ),
            ),
          ),

          // Nav 1: Tombol Tengah (Plant)
          Positioned(
            top: 10, 
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => onTap(1),
              child: Center(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/ic_plant.svg',
                      height: 35,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi Helper untuk membuat Ikon + Eclipse
  Widget _buildNavItem(String assetPath, int index) {
    bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            height: 28,
            colorFilter: ColorFilter.mode(
              isActive ? const Color(0xFF0A910A) : Colors.grey,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          // Indikator Eclipse (Lingkaran kecil di bawah)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFF0A910A) : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
