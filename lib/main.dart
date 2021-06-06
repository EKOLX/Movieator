import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart' as webPicker;
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import './movie.dart';
import 'dart:html' as html;

void main() => runApp(MainApp());

class MovieModel {}

class FileManager {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/movies.txt');
  }

  Future<String> readMovieFile() async {
    try {
      final file = await _localFile;
      final content = await file.readAsString();
      return content;
    } catch (ex) {
      print(ex.toString());
      return "";
    }
  }

  Future<List<Map<String, String>>> getMovies() async {
    List<Map<String, String>> collection = <Map<String, String>>[];

    if (kIsWeb) {
      webPicker.FilePickerResult? result =
          await webPicker.FilePicker.platform.pickFiles();
      if (result != null) {
        webPicker.PlatformFile file = result.files.first;
        String fileContent = utf8.decode(file.bytes?.toList() ?? []);
        List<String> lines = fileContent.split('\n');
        for (var line in lines) {
          var el = line.split('@#');
          collection.add({"name": el[1], "link": el[0]});
        }
      } else {
        // User canceled the picker
      }
    }

    return collection;
  }
}

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  var movies = [
    {'name': 'Movie 43', 'link': "http://"},
    {'name': 'Movie 69', 'link': "http://"}
  ];
  List<Map<String, String>> _uploadedMovies = [];
  int _randomIndex = 0;

  void uploadMovies() {
    FileManager().getMovies().then((List<Map<String, String>> list) {
      setState(() {
        _uploadedMovies = list;
      });
    });
  }

  void generatePressed() {
    Random random = Random();
    setState(() {
      _randomIndex = random.nextInt(_uploadedMovies.length);
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
          ...movies.map((movie) {
            return Movie(movie['name'].toString());
          }),
          Container(
            child: Text(
              'Press button to generate random choice',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            width: double.infinity,
            margin: EdgeInsets.all(12),
          ),
          Container(
            child: kIsWeb && _uploadedMovies.length == 0
                ? ElevatedButton(
                    onPressed: uploadMovies, child: Text("Upload movies"))
                : null,
          ),
          Container(
              child: _uploadedMovies.length > 0
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Movie(_uploadedMovies[_randomIndex]['name']
                                .toString()),
                            ElevatedButton(
                              onPressed: () {
                                html.window.open(
                                    _uploadedMovies[_randomIndex]['link']
                                        .toString(),
                                    'new tab');
                              },
                              child: Text("Open in new tab"),
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        ElevatedButton(
                            onPressed: generatePressed,
                            child: Text('Generate')),
                      ],
                    )
                  : null)
        ],
      ),
    ));
  }
}
