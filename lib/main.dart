import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:myapp/constants/api_key.dart';

import 'presentation/home_page.dart';

void main() {
  Gemini.init(apiKey: ApiKey.api_key);
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Gemini Vision",
      home: HomePage(),
    );
  }
}
