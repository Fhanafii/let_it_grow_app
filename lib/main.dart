import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:let_it_grow_app/features/auth/view/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/plant/viewmodel/plant_viewmodel.dart';
import 'features/auth/view/login_screen.dart';
import 'features/plant/view/setup_plant_screen.dart';
import 'features/plant/view/home_screen_wrapper.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    )
  );

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => PlantViewModel()),
        ],
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Let It Grow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',
      routes:  {
        '/': (context) => const AuthGate(),
        '/login': (context) => LoginScreen(),
        '/setup-plant': (context) => const SetupPlantScreen(),
        '/home': (context) => const HomeScreenWrapper(),
      },
    );
  }
}
