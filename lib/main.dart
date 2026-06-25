import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Setup Firebase when configuration is available
  // await Firebase.initializeApp();
  
  runApp(
    const ProviderScope(
      child: ResQApp(),
    ),
  );
}
