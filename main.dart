import 'dart:io';

import 'package:cabdriver/dataprovider.dart';
import 'package:cabdriver/globalvariables.dart';
import 'package:cabdriver/screen/login.dart';
import 'package:cabdriver/screen/mainpage.dart';
import 'package:cabdriver/screen/registration.dart';
import 'package:cabdriver/screen/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
      googleAppID: '1:297965724061:ios:c6de2b69b03a5be8',
      gcmSenderID: '297855924061',
      databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
    )
        : const FirebaseOptions(
      googleAppID: '1:899977965877:android:359658714d063b85830526',
      apiKey: 'AIzaSyDaWtd7965ds5f7s5c98mp66f7_iNwP4VdO5Q',
      databaseURL: 'https://geetaxi-efe9e-default-rtdb.firebaseio.com',
    ),
  );

  currentFirebaseUser= await FirebaseAuth.instance.currentUser();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Brand-Regular',

          primarySwatch: Colors.blue,
        ),
        initialRoute: (currentFirebaseUser == null)? LoginPage.id: MainPage.id,
//      initialRoute: LoginPage.id,
        routes: {
          MainPage.id: (context)=> MainPage(),
          RegistrationPage.id: (context)=> RegistrationPage(),
          VehicleInfoPage.id:(context)=> VehicleInfoPage(),
          LoginPage.id : (context)=> LoginPage()
        },
      ),
    );
  }
}
