import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:let_it_grow_app/features/plant/view/chart_screen.dart';
import 'package:let_it_grow_app/features/plant/viewmodel/plant_viewmodel.dart';
import '../widgets/custom_topbar_painter.dart';
import 'package:provider/provider.dart';
import '../widgets/xp_bar_widget.dart';
import '../model/plant_model.dart';
import '../widgets/plant_anim_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil cuaca saat pertama kali masuk Home
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantViewModel>().updateWeatherWithLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plantVM = context.watch<PlantViewModel>();
    double screenWidth = MediaQuery.of(context).size.width;
    double topBarHeight = 150; 

      return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),// 0xFFF1F8F1
        // extendBody: true,
        body: Column( // Ganti SingleChildScrollView jadi Column
          children: [
            // 1. TOP BAR (Tetap di atas)
            Stack(
              alignment: Alignment.topCenter,
              children: [
                CustomPaint(
                  size: Size(screenWidth, topBarHeight),
                  painter: RPSCustomPainter(),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5), // 10
                    child: Column(
                      children: [
                        const XpBarWidget(currentXp: 450, maxXp: 1000),
                        const SizedBox(height: 10), // 15
                        _buildStatusRow(plantVM),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 2. ANIMASI DI TENGAH (MENGISI SISA LAYAR)
            Expanded( // Widget ini akan mengambil semua sisa ruang yang ada
              child: Center(
                child: const PlantAnimWidget(),
              ),
            ),

            // 3. SPACE UNTUK BOTTOM NAV (Opsional)
            // Jika kamu menggunakan Scaffold dengan extendBody: true, 
            // kamu bisa menambah SizedBox di bawah agar animasi sedikit naik.
            const SizedBox(height: 150), // 200 
          ],
        ),
      );
  }

  // Widget Helper untuk 3 Status di bawah XP Bar
  Widget _buildStatusRow(PlantViewModel plantVM) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Kiri: Moisture
        StreamBuilder<MoistureData?>(
          stream: plantVM.getLatestMoistureStream(),
          builder: (context, snapshot) {
            final moisture = snapshot.data?.percentage.toInt() ?? 0;
            return _statusItem('assets/ic_moisture.svg', "$moisture%");
          },
        ),

        // Tengah: Online/Offline Status
        StreamBuilder<MoistureData?>(
          stream: plantVM.getLatestMoistureStream(),
          builder: (context, snapshot) {
            final bool onlineStatus = snapshot.data != null ? snapshot.data!.isStillOnline : false;
            return _statusOnline(isOnline: onlineStatus);
          },
        ),

        _statusItem(
          'assets/ic_weather.svg', 
          "${plantVM.currentWeatherData?.temp.toStringAsFixed(0) ?? '--'}°C"
        ),
      ],
    );
  }

  Widget _statusItem(String assetPath, String value) {
    return Row(
      children: [
        SvgPicture.asset(assetPath, height: 20),
        const SizedBox(width: 5),
        Text(value, style: const TextStyle(color: Color(0xFF0A910A), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _statusOnline({required bool isOnline}) {
    // Tentukan warna berdasarkan state
    Color stateColor = isOnline ? const Color(0xFF0A910A) : const Color(0xFFD91A1A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5), // Sedikit lebih tebal agar terbaca
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: stateColor, // Titik jadi merah jika offline
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? "Online" : "Offline",
            style: TextStyle(
              color: stateColor, // Teks jadi merah jika offline
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
