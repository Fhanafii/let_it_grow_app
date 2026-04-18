import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:let_it_grow_app/features/plant/viewmodel/plant_viewmodel.dart';
import 'package:provider/provider.dart';
import '../widgets/plant_chart_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/plant_model.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A910A);
    final plantVM = context.watch<PlantViewModel>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8), // Background agak putih kehijauan
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text("Hey ${plantVM.userName}", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)
              ),
              const Text("Ayo Kita lihat kondisi tanamanmu", 
                style: TextStyle(fontSize: 14, color: Colors.grey)),
              
              const SizedBox(height: 30),

              // Statistic Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Statistic", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => plantVM.setFilter(ChartFilter.today),
                        child: _buildTabButton("Today", plantVM.activeFilter == ChartFilter.today),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => plantVM.setFilter(ChartFilter.month),
                        child: _buildTabButton("Month", plantVM.activeFilter == ChartFilter.month),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),

              // Chart Box
              Container(
                height: 250,
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: StreamBuilder<List<MoistureData>>( 
                  stream: plantVM.getMoistureHistoryStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: primaryColor));
                    }
                    
                    if (snapshot.hasError) {
                      return const Center(child: Text("Gagal memuat data"));
                    }

                    final moistureList = snapshot.data ?? [];
                    
                    if (moistureList.isEmpty) {
                      return const Center(child: Text("Belum ada data sensor"));
                    }

                    // DI SINI baru kita konversi List<MoistureData> menjadi List<FlSpot>
                    // Menggunakan fungsi helper yang sudah kamu buat di ViewModel
                    final List<FlSpot> points = plantVM.mapToSpots(moistureList);

                    // Masukkan points (List<FlSpot>) ke widget chart
                    return PlantChartWidget(
                      points: plantVM.mapToSpots(moistureList),
                      rawData: moistureList,
                      );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Status Card Section
              const Text("Status Card", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusCard(
                    "Temperature", 
                    "${plantVM.currentWeatherData?.temp.toStringAsFixed(1) ?? '--'}° C", 
                    "assets/ic_weather.svg" 
                  ),
                  const SizedBox(width: 2),
                  _buildStatusCard("Plant", "1", "assets/ic_plant_chart.svg", ),
                  const SizedBox(width: 2),
                  StreamBuilder<MoistureData?>(
                    stream: plantVM.getLatestMoistureStream(),
                    builder: (context, snapshot) {
                      final moisture = snapshot.data?.percentage.toInt() ?? 0;
                      return _buildStatusCard(
                        "Moisture", 
                        "$moisture %", 
                        "assets/ic_moisture.svg"
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk Tombol Today/Month
  Widget _buildTabButton(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0A910A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, 
        style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  // Helper Widget untuk Status Card
  Widget _buildStatusCard(String title, String value, String svgAsset) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF0A910A).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(svgAsset, height: 35),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, fontFamily: 'Poppins', color: Color(0xFF0A910A))),
          Text(value, style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Color(0xFF0A910A))),
        ],
      ),
    );
  }
}
