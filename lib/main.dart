import 'package:flutter/material.dart';
import 'widget/kakao_map.dart' as kakaoMap;

void main() {
  runApp(
    MaterialApp(
      home: MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비급여수가'),
      ),
      body: kakaoMap.KakaoMap(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'Main'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: 'Main2')
        ],
      ),
    );
  }
}
