import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_bottom_navbar.dart';
import 'home_screen.dart';
import '../../settings/view/settings_screen.dart';
import '../view/chart_screen.dart';

class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  State<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  int _selectedIndex = 1; // Default ke halaman tengah (Plant)

  // List halaman yang akan ditampilkan
  final List<Widget> _screens = [
    const ChartScreen(), // Indeks 0
    const HomeScreen(), // Indeks 1
    const SettingsScreen(), // Indeks 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      extendBody: true, 
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
