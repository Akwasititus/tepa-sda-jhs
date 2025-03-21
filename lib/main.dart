import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Auth/login.dart';
import 'firebase_options.dart';


Future<void> main() async {
  // await dotenv.load(fileName: '.env');
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDA SCHOOL APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:
        Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

