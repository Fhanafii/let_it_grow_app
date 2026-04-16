import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  
  bool _isLoading = false;
  bool _isNavigating = false;

  bool get isLoading => _isLoading;
  bool get isNavigating => _isNavigating;

  User? get user => _repository.currentUser;

  Future<void> login(BuildContext context) async {
    _isLoading = true;
    _isNavigating = false;
    notifyListeners();

    try {
      await _repository.signInWithGoogle();
      _isLoading = false;
      _isNavigating = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));
      final hasDevice = await _repository.hasRegisteredDevice();

      if (context.mounted) {
        if(hasDevice){
          Navigator.pushReplacementNamed(context, '/home');
        }else{
          Navigator.pushReplacementNamed(context, '/setup-plant');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login dibatalkan oleh pengguna')),
      );
    } finally {
      _isLoading = false;
      _isNavigating = false;
      notifyListeners();
    }
  }

  Future<void> determineInitialRoute(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final session = _repository.currentSession;

    if (session == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final hasDevice = await _repository.hasRegisteredDevice();
      if (context.mounted) {
        if (hasDevice) {
          // Sudah login & sudah punya alat -> Dashboard
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Sudah login & BELUM punya alat -> Setup Guide
          Navigator.pushReplacementNamed(context, '/setup-plant');
        }
      }
    } catch (e) {
      print("DEBUG ERROR: $e");
      if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Debug fungsi: Langsung pindah ke setup screen tanpa login
  void debugNavigateToSetup(BuildContext context) async{
    // debug loading screen selama 2 detik
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();

    Navigator.pushReplacementNamed(context, '/home');
  }
}