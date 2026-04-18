import 'package:flutter/material.dart';

class PlantAnimWidget extends StatefulWidget {
  const PlantAnimWidget({super.key});

  @override
  State<PlantAnimWidget> createState() => _PlantAnimWidgetState();
}

class _PlantAnimWidgetState extends State<PlantAnimWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  final int _totalFrames = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // Sesuaikan durasi, 240 frame biasanya enak di mata dalam 3-5 detik
      duration: const Duration(seconds: 3), 
    );

    // Tween dari frame 1 sampai 240
    _animation = IntTween(begin: 1, end: _totalFrames).animate(_controller);
  }

  void _playAnimation() {
    if (_controller.isAnimating) return; // Cegah double tap saat main
    
    // Putar animasi dari awal
    _controller.forward(from: 0).then((_) {
      _controller.reset(); // balik ke frame 1
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAnimation, // Jalankan animasi saat disentuh
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // Asumsi nama file: 1.png, 2.png, ... 240.png
          // Jika ada prefix (misal 'frame_1.png'), sesuaikan di sini
          String frameName = _animation.value.toString().padLeft(3, '0');
          
          return Image.asset(
            'assets/happy_to_sad/ezgif-frame-$frameName.png',
            // width: 556, // Sesuaikan ukuran
            height: 720,
            fit: BoxFit.contain,
            // Penting agar transisi antar frame mulus tanpa kedip
            gaplessPlayback: true, 
          );
        },
      ),
    );
  }
}
