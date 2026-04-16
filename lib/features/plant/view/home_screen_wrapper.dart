import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_bottom_navbar.dart'; // Import painter hasil konversi tadi

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Default ke halaman tengah (Plant)

  // List halaman yang akan ditampilkan
  final List<Widget> _screens = [
    const Center(child: Text("Chart Screen")), // Indeks 0
    const Center(child: Text("Monitoring Screen")), // Indeks 1
    const Center(child: Text("Settings Screen")), // Indeks 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),
      body: Stack(
        children: [
          // 1. Tampilkan layar sesuai index
          _screens[_selectedIndex],

          // 2. Gunakan Custom Navbar yang baru dibuat
          Positioned(
            bottom: 0,
            child: CustomBottomNavbar(
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
