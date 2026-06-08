import 'package:flutter/material.dart';
import 'package:motocare/core/theme/app_theme.dart';
import 'package:motocare/widgets/main_wrapper.dart';

void main() {
  runApp(const CustomerApp());
}

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MotoCare - Customer',
      theme: AppTheme.lightTheme,
      home: const MainWrapper(),
    );
  }
}
