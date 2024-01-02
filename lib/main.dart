import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pfamobile/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAj5CkivXKyMNZawAErSu5aoi52chwpNgI",
      authDomain: "pfamobilee.firebaseapp.com",
      projectId: "pfamobilee",
      storageBucket: "pfamobilee.appspot.com",
      messagingSenderId: "914864429412",
      appId: "1:914864429412:android:d55ea1912f14e60f760271",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: Register(),
    );
  }
}
