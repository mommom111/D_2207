import 'package:flutter/material.dart';
import 'package:freedom/view/pages/beacon_scanning_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: congestionPage(),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const BeaconScanningPage(),
    );
  }
}

class congestionPage extends StatefulWidget {
  const congestionPage({super.key});

  @override
  State<congestionPage> createState() => _congestionPageState();
}

class _congestionPageState extends State<congestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FFL'),
      ),
    );
  }
}