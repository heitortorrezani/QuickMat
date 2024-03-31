import 'package:embrasa2/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/abrtura/abertura.dart';
import 'pages/homePage.dart';
import 'pages/matematica/matematica.dart';
import 'pages/matematica/perg_mat/espera2/wait2.dart';
import 'pages/sala espara/wait.dart';
import 'pages/sala espara/wait_votos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBXawJB08lNs0w2iPStzYhKQnll5UMfqwE",
        authDomain: "fir-exable4.firenobaseapp.com",
        projectId: "fir-exable4",
        storageBucket: "fir-exable4.appspot.com",
        messagingSenderId: "585192313369",
        appId: "1:585192313369:web:75fe42485c7fa73a499088"
      ),
    );
  }
  catch(e){
    print('erro $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickMath',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.purple[900],
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurpleAccent,
        ),
      ),
      routes: {
        "/": (_) => const Login(),
        "/A": (_) => const Abertura(),
        "/wait": (_) => const Wait(),
        "/home": (_) => const HomePage(),
        "/votos": (_) => const WaitVotos(), 
        "/matematica": (_) => const Matematica(), 
        "/wait2": (_) => const Wait2(),
      },
    );
  }
}