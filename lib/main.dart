import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;


import 'package:app_qr_negocio/src/bloc/provider.dart';
import 'package:app_qr_negocio/src/shared_preferences/shared_preferences.dart';

import 'package:app_qr_negocio/src/pages/home_page.dart';
import 'package:app_qr_negocio/src/pages/login_page.dart';
import 'package:app_qr_negocio/src/pages/register_page.dart';
import 'package:app_qr_negocio/src/pages/disclaimer_page.dart';
import 'package:app_qr_negocio/src/pages/scanned_data_page.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
    ]);

  // ignore: unused_local_variable
  final FirebaseApp app = await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: '1:853107174977:android:7d0048414f20f4bbf960c0',
      apiKey: 'AIzaSyBThFX1tranSrVdeJG1LnZCb48Ac1LzUjw',
      databaseURL: 'https://qr-app-cliente.firebaseio.com',
      messagingSenderId: '853107174977',
      projectId: 'qr-app-negocios',
    )
  );

  final prefs = new SavedData();
  await prefs.initPrefs();

  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
        ],
        title: 'MiQR Negocios',
        initialRoute: 'login',
        routes: {
          'home'          :(BuildContext context)       =>HomePage(),
          'scanned'       :(BuildContext context)       =>ScannedDataPage(),
          'login'         :(BuildContext context)       =>LoginPage(),
          'register'      :(BuildContext context)       =>RegisterPage(),
          'disclaimer'    :(BuildContext context)       =>DisclaimerPage(),
          
        },
        theme: ThemeData(
          
          primaryColor: Colors.purple,
          accentColor:  Colors.purpleAccent
        ),
      ),
    );
  }
}