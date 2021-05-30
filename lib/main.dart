import 'package:flutter/material.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  var list = ['Item1', 'Item2'];
  int listIndex = 0;

  void generatePressed() {
    setState(() {
      listIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Movieator'),
      ),
      body: Column(
        children: [
          Text(list[listIndex]),
          Container(
            child: Text(
              'Press button to generate random choice',
              style: TextStyle(fontSize: 23),
              textAlign: TextAlign.center,
            ),
            width: double.infinity,
            margin: EdgeInsets.all(12),
          ),
          ElevatedButton(child: Text('Generate'), onPressed: generatePressed)
        ],
      ),
    ));
  }
}
