import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:core/core.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase may not be configured yet - continue without it for now
    debugPrint('Firebase initialization skipped: $e');
  }
  
  // Initialize DI
  await InjectionContainer.init();
  
  // Initialize screen protection
  try {
    await ScreenProtector.protectDataLeakageOn();
    // Note: protectScreenshotOn may need different API - check screen_protector docs
  } catch (e) {
    // Screen protection may not be available on all devices
    debugPrint('Screen protection not available: $e');
  }
  
  runApp(const BankStatementApp());
}
