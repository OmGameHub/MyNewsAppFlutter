import 'package:flutter/material.dart';

import 'MyHomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyNews",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: ThemeData.dark(),
      home: MyHomePage()
    );
  }
}

ThemeData lightTheme = ThemeData(
  primaryColor: Color(0xFF27ae60),
  accentColor: Color(0xFF2ecc71),
  textSelectionHandleColor: Color(0xFF2ecc71),
);