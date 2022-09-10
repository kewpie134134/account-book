import 'package:account_book/app_root.dart';
import 'package:account_book/config/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Firebase のシークレット情報を取得
final Configurations configurations = Configurations();

void main() async {
  // Flutter Engine を利用する際の宣言（Firebase を利用する際は必要）
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: configurations.apiKey,
      authDomain: configurations.authDomain,
      projectId: configurations.projectId,
      messagingSenderId: configurations.messagingSenderId,
      appId: configurations.appId,
      measurementId: configurations.measurementId,
    ),
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "NotoSansJP",
      ),
      home: const AppRoute(),
      // DatePicker を日本語表示にする設定
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("ja"),
      ],
    );
  }
}
