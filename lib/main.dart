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
              width: 320,
              child: Text('食堂1'),
            ),
            Container(
              width: 340,
              height: 210,
              decoration: BoxDecoration(
                color: Colors.purple,
                border: Border.all(width: 4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 280,
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('大混雑', 
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 50)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text('')
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(9),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text('今日はいつもより人が多いです！')
                          ),
                          Container(
                            margin: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            ),
                            child: ElevatedButton(
                            child: const Text('評価 : ⭐️⭐️⭐️', style: TextStyle(color: Colors.black,),),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {},
                          ),


                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
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