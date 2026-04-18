import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class XpBarWidget extends StatefulWidget {
  final double currentXp;
  final double maxXp;

  const XpBarWidget({
    super.key,
    required this.currentXp,
    required this.maxXp,
  });

  @override
  State<XpBarWidget> createState() => _XpBarWidgetState();
}

class _XpBarWidgetState extends State<XpBarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Durasi animasi 1.5 detik
    );

    double progress = (widget.currentXp / widget.maxXp).clamp(0.0, 1.0);
    _animation = Tween<double>(begin: 0, end: progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(XpBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentXp != widget.currentXp) {
      double progress = (widget.currentXp / widget.maxXp).clamp(0.0, 1.0);
      _animation = Tween<double>(begin: _animation.value, end: progress).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Teks XP
        Text(
          "${widget.currentXp.toInt()} / ${widget.maxXp.toInt()} XP to grow",
          style: const TextStyle(
            color: Color(0xFF0A910A),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        
        // Base XP Bar dengan Sunflower
        Stack(
          clipBehavior: Clip.none, // Agar bunga tidak terpotong
          children: [
            // Container Utama (Background & Border)
            Container(
              width: 387, // Sesuai permintaan (akan otomatis menyesuaikan jika layar lebih kecil)
              constraints: const BoxConstraints(maxWidth: double.infinity),
              height: 21,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0), // Abu-abu background
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF0A910A), // Stroke Hijau
                  width: 1.5,
                ),
              ),
            ),

            // Animated Fill
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 387 * _animation.value,
                  height: 21,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBC04), // Warna Fill Oranye
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF0A910A),
                      width: 1,
                    )
                  ),
                );
              },
            ),

            // Asset Bunga Matahari di Pojok Kanan
            Positioned(
              right: -5, 
              top: -30, // Atur posisi agar bunganya "tumbuh" di atas bar
              child: SvgPicture.asset(
                'assets/ic_sunflower.svg', // Pastikan nama file sesuai
                height: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
