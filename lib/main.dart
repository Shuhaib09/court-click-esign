import 'package:flutter/material.dart';
import 'screens/esign/esign_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Court Click',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const EsignListScreen(),
    );
  }
}
