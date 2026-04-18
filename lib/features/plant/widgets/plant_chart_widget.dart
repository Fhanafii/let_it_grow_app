import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../model/plant_model.dart';

class PlantChartWidget extends StatelessWidget {
  final List<FlSpot> points;
  final List<MoistureData> rawData;

  const PlantChartWidget({super.key, required this.points, required this.rawData});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A910A);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: Color(0xFFE0E0E0),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: (value, meta) {
                // Tampilkan label setiap kelipatan 250 agar tidak tumpang tindih
                if (value % 250 == 0) {
                  return Text(value.toInt().toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12));
                }              
                return const SizedBox();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
              //AMBIL JAM ASLI DARI DATA
              int index = value.toInt();
              if (index % 5 == 0 && index < rawData.length) { // Tampilkan setiap 5 titik
                DateTime time = rawData[index].createdAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "${time.hour}:${time.minute}", 
                    style: const TextStyle(color: Color(0xFF0A910A), fontSize: 10)
                  ),
                );
              }
              return const SizedBox();
            }
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            color: primaryColor,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            // PERBAIKAN: Gunakan belowBarData, bukan belowArea
            belowBarData: BarAreaData(
              show: true,
              color: primaryColor.withOpacity(0.1),
            ),
          ),
        ],
        // Set range Y agar konsisten 0-100% atau sesuai data sensor
        minY: 0,
        maxY: 1050, 
      ),
    );
  }
}
