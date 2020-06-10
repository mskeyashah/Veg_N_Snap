import 'dart:async';

import 'package:flutter/material.dart';
import 'package:VegNSnap/loginPage.dart';
import 'package:VegNSnap/onboardingscreen.dart';
import 'package:camera/camera.dart';
import 'package:VegNSnap/cameraPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  if(initScreen==0 || initScreen == null)
    runApp(MyApp());
  else
    runApp(LoginPage());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initScreen == 0 || initScreen == null ? "first" : "/",
      routes: {
        "first": (context) => OnboardingScreen(),
      },
    );
  }
}