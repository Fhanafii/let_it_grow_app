import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

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

  User? get currentUser => _supabase.auth.currentUser;

}