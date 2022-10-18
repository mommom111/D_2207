import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: congestionPage(),
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
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 1.8, color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  children: [
                    Text('混雑度',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Text('食堂1'),
            ),
          ],
        ),
      ),
    );
  }
}

class pageTitle extends StatelessWidget {
  const pageTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(width: 1.8, color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
          child: Center(
            child: Column(
              children: [
                Text('混雑度',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}