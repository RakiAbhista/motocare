import 'package:flutter/material.dart';

/// Global navigator key untuk mengontrol navigasi dari mana saja,
/// terutama untuk menangani tap notifikasi saat aplikasi terminated atau di background.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
