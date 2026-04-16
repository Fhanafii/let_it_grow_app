import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Jangan lupa install provider
import '../viewmodel/auth_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../plant/view/loading_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

        return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                SvgPicture.asset('assets/logo.svg', height: 120),
                const SizedBox(height: 16),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 59,
                  child: ElevatedButton.icon( // Button Sign-in
                    icon: SvgPicture.asset('assets/google_logo.svg', height: 24),
                    label: const Text('Sign in with Google', 
                      style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: Colors.white)),
                    onPressed: authVM.isLoading || authVM.isNavigating ? null : () => authVM.login(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A910A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                TextButton( // Debug text Button
                  onPressed: () => authVM.debugNavigateToSetup(context),
                  child: const Text('Debug: Go to Setup', style: TextStyle(color: Colors.grey)),
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
        // Tampilkan loading jika sedang proses
        if (authVM.isNavigating) const LoadingScreen(), 
      ],
    );
  }
}
