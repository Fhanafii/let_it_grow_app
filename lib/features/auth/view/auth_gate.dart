import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Jangan lupa install provider
import '../viewmodel/auth_viewmodel.dart';
import '../../plant/view/loading_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    // Jalankan logika penentu rute setelah widget render pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().determineInitialRoute(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingScreen();
  }
}
