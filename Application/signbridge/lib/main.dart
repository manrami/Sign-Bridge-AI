import 'package:flutter/material.dart';

// Import pages with aliases
import 'pages/Homepage.dart';
import 'pages/Loadingpage.dart';
import 'pages/EngToSignPage.dart' as engToSignPage;
import 'pages/TextTranslationPage.dart';
import 'pages/TranslationResultPage.dart';
import 'pages/SignToEnglishPage.dart' as signToEngPage;
import 'pages/SignToTextPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SignBridge",
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/loading',
      routes: {
        '/home': (context) => Homepage(),
        '/loading': (context) => Loadingpage(),
        '/eng_to_sign': (context) => engToSignPage.EngToSignPage(),
        '/text_translation': (context) => TextTranslationPage(),
        '/translation_result': (context) => TranslationResultPage(),
        '/sign_to_english': (context) => signToEngPage.SignToEnglishPage(),
        '/sign_to_text': (context) => SignToTextPage(),
      },
    );
  }
}
