import 'package:flutter/material.dart';
import 'package:sql_todo_app/pages/home_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: false),
      home: HomeScreen(),
    );
  }
}


/*Supported SQLite types 
 
 INTEGER
  - Dart type: int
  - Supported values: from -2^63 to 2^63 - 1

 REAL
  - Dart type: num

 TEXT
  - Dart type: String

 BLOB
 - Dart type: Uint8List
  */