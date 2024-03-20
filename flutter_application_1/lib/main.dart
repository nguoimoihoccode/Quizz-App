import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/helper/functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/views/signin.dart';
import 'package:easy_localization/easy_localization.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  if (kIsWeb) {
    // Khởi tạo Firebase cho web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCyfKpsvYJK12RX5ASHWWJthx-IaoeYjVs',
        appId: '1:633580983212:web:d11cee10d8562df7c22009',
        messagingSenderId: '633580983212',
        projectId: 'quiz-4247e',
        storageBucket: 'quiz-4247e.appspot.com',
      ),
    ); 
  }
  else{
    Platform.isAndroid ? await Firebase.initializeApp(
      options: const FirebaseOptions(
      apiKey: 'AIzaSyCyfKpsvYJK12RX5ASHWWJthx-IaoeYjVs', 
      appId: '1:633580983212:web:d11cee10d8562df7c22009', 
      messagingSenderId: '633580983212',  
      projectId: 'quiz-4247e',
      storageBucket: 'gs://quiz-4247e.appspot.com')) 
    : await Firebase.initializeApp();
  }
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ], 
      path: "assets/translations",
      child: const MyApp()
    ), 
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedin = false;
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    //checkUserLoggedInStatus();
    super.initState();
  }

  checkUserLoggedInStatus() async {
    HelperFunctions.getUserLoggedInDetails().then((value){
      setState(() {
        _isLoggedin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)?.locale;
    print(currentLocale);
    return MaterialApp(
      title: 'Quiz App',
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      
      home: const SignIn(),
    );
  }
}