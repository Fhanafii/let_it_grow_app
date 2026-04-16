import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  Session? get currentSession => _supabase.auth.currentSession;

  Future<AuthResponse> signInWithGoogle() async {
    final webClientId = dotenv.get('GOOGLE_WEB_CLIENT_ID'); // Ambil dari .env

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accesToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accesToken == null || idToken == null ){
      throw Exception('Missing Google Auth Token');
    }

    return _supabase.auth.signInWithIdToken(provider: OAuthProvider.google, idToken: idToken, accessToken: accesToken);
  }

  Future<void> signOut() => _supabase.auth.signOut();

  Future<bool> hasRegisteredDevice() async {
    final userId = _supabase.auth.currentUser?.id;
    if(userId == null) return false;

    try {
      final response = await _supabase
          .from('device_auth')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      // Mengembalikan true jika ada data, flase jika null
      return response != null;
    } catch(e) {
      rethrow; // biarkan ViewModel yang menangani error
    }
  }

  User? get currentUser => _supabase.auth.currentUser;

}