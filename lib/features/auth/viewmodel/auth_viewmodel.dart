import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get user => _repository.currentUser;

  Future<void> login(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.signInWithGoogle();
      // Navigasi ke Plant Screen jika sukses
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/plant-screen');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login dibatalkan oleh pengguna')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
