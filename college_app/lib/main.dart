import 'package:flutter/material.dart';
import 'package:hospital_app/admin/notifier_admin.dart';
import 'package:hospital_app/home.dart';
import 'package:hospital_app/patient/notifier_student.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Add your providers here
        ChangeNotifierProvider(create: (context) => notifier_admin()),

        ChangeNotifierProvider(create: (context) => notifier_student()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const home(),
    );
  }
}
