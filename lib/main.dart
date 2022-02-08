import 'package:flutter/material.dart';
import 'widget/findAddress.dart';
import 'widget/findMyGps.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '비급여수가',
      home: MyHomePage(title: '비급여수가'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> widgets = [FindAddress(), FindMyGps()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.center,
        child: GridView.count( // Grid 설정
          crossAxisCount: 2,
          children: List.generate(widgets.length, (index) {
            return Center(
              child: widgets[index]
            );
          }),
        ),
      ),
    );
  }
}