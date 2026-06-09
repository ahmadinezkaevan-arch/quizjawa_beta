import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF583410),
          surface:                 const Color(0xFFF5F5F5),
          surfaceContainerHighest: const Color(0xFFF5F5F5),
          surfaceContainerHigh:    const Color(0xFFF5F5F5),
          surfaceContainer:        const Color(0xFFF5F5F5),
          surfaceContainerLow:     const Color(0xFFF5F5F5),
          surfaceContainerLowest:  const Color(0xFFF5F5F5),
          surfaceDim:              const Color(0xFFF5F5F5),
          surfaceBright:           const Color(0xFFF5F5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        canvasColor:             const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
    );
  }
}