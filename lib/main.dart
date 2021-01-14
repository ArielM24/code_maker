import 'package:flutter/material.dart';
import "package:filesystem_picker/filesystem_picker.dart";
import 'dart:io';
import 'package:code_maker/coder.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MainWindow());
}

class MainWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MainWindow_(),
    );
  }
}

// ignore: camel_case_types
class _MainWindow_ extends StatefulWidget {
  @override
  createState() => _MainWindow();
}

class _MainWindow extends State<_MainWindow_> {
  String _filePath = "";
  File file;
  var selectedLangs = <bool>[];
  var functionalCode = false;
  var checkboxes;
  bool generated = false;
  var _textControllers = [];
  var langs = <String>[
    "C",
    "C++",
    "Java",
    "Python",
    "Go",
    "Dart",
  ];
  var _scrollPreview = ScrollController();
  Size screenSize;
  var _previewWidth = 500.0;
  var _cbheight = 60.0;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print(screenSize.width);
    print(screenSize.height);
    _previewWidth = screenSize.width - 320;
    _cbheight = screenSize.height * 0.0857142857143;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Diagrama Coder"),
          ),
          body: createMainBody()),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
        accentColor: Colors.blue,
      ),
    );
  }

  Widget createMainBody() {
    checkboxes = _generateCheckBox(langs);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 300, minHeight: 700),
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        "File:$_filePath",
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        RaisedButton(
                            onPressed: _selectFile, child: Text("Open")),
                        SizedBox(
                          width: 20,
                        ),
                        RaisedButton(
                            onPressed: _createPreview, child: Text("Preview")),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: CheckboxListTile(
                        title: Text("Function"),
                        value: functionalCode,
                        onChanged: (val) {
                          setState(() {
                            functionalCode = val;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                checkboxes[0],
                checkboxes[1],
                checkboxes[2],
                checkboxes[3],
                checkboxes[4],
                checkboxes[5],
                Row(
                  children: [
                    RaisedButton(
                      onPressed: langSelected() ? _createFiles : null,
                      child: Text("Create"),
                      disabledColor: Colors.blue,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      onPressed: langSelected() ? _cleanPreview : null,
                      child: Text("Clean"),
                      disabledColor: Colors.blue,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        _makePreview()
      ],
    );
  }

  List<Widget> _generateCheckBox(List<String> langs) {
    List<Widget> cbs = [];
    for (int i = 0; i < langs.length; i++) {
      if (!generated) {
        selectedLangs.add(i == 0);
      }
      cbs.add(SizedBox(
        width: 200,
        height: _cbheight,
        child: CheckboxListTile(
          contentPadding: EdgeInsets.only(bottom: 5),
          controlAffinity: ListTileControlAffinity.platform,
          dense: true,
          value: selectedLangs[i],
          onChanged: (bool val) {
            setState(() {
              selectedLangs[i] = val;
              print(val);
            });
          },
          title: Text(langs[i]),
        ),
      ));
    }
    generated = true;
    return cbs;
  }

  bool langSelected() {
    var selected = false;
    for (var i in selectedLangs) {
      selected |= i;
    }
    print(selectedLangs);
    print(selected);
    return selected;
  }

  Widget _makePreview() {
    return SizedBox(
      child: Container(
        color: Colors.grey[900],
        child: Scrollbar(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ListView(
                  children: _makePreviewItems(langs),
                  controller: _scrollPreview),
            ),
            isAlwaysShown: true,
            controller: _scrollPreview),
      ),
      width: _previewWidth,
      height: 500,
    );
  }

  List<Widget> _makePreviewItems(List<String> _langs) {
    List items = <Widget>[];
    for (int i = 0; i < langs.length; i++) {
      if (items.length <= langs.length * 3) {
        _textControllers.add(TextEditingController());
        items.add(Container(
          color: Colors.blue,
          width: 500,
          height: 30,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              langs[i],
            ),
          ),
        ));
        items.add(
          TextField(
            controller: _textControllers[i],
            minLines: 5,
            maxLines: 25,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        );
        items.add(Divider());
      }
    }
    return items;
  }

  _selectFile() async {
    var fileRes = await FilesystemPicker.open(
        title: 'Open',
        context: context,
        rootDirectory: Directory(await getDocsPath()),
        fsType: FilesystemType.file,
        allowedExtensions: [".json", ".df"]);
    file = File(fileRes);

    print(file.path);
    setState(() {
      _filePath = file != null ? file.path : "";
    });
  }

  Future<String> getDocsPath() async {
    String readPath;
    String user = Platform.environment["UserProfile"];
    print(user);
    if (Platform.isWindows) {
      readPath = "$user\\Documents\\";
    } else {
      readPath = (await getApplicationDocumentsDirectory()).path;
    }
    return readPath;
  }

  getCodeIndex(index, coder) {
    switch (index) {
      case 0:
        if (functionalCode)
          return coder.getFuncC();
        else
          return coder.getCodeC();
        break;
      case 1:
        if (functionalCode)
          return coder.getFuncCpp();
        else
          return coder.getCodeCpp();
        break;
      case 2:
        if (functionalCode)
          return coder.getFuncJava();
        else
          return coder.getCodeJava();
        break;
      case 3:
        if (functionalCode)
          return coder.getFuncPython();
        else
          return coder.getCodePython();
        break;
      case 4:
        if (functionalCode)
          return coder.getFuncGo();
        else
          return coder.getCodeGo();
        break;
      case 5:
        if (functionalCode)
          return coder.getFuncDart();
        else
          return coder.getCodeDart();
        break;
    }
  }

  _createPreview() async {
    var data = await readJson(file);
    var coder = Coder.fromRaw(data);
    for (int i = 0; i < selectedLangs.length; i++) {
      {
        if (selectedLangs[i]) {
          String code = getCodeIndex(i, coder);
          _textControllers[i].text = code;
        }
      }
    }
  }

  _cleanPreview() {
    for (var txt in _textControllers) {
      txt.text = "";
    }
  }

  _createFiles() async {
    await _createPreview();
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path +
        Platform.pathSeparator +
        "CoderOutputs" +
        Platform.pathSeparator;
    Directory d = Directory(path);
    if (!await d.exists()) await d.create();
    if (selectedLangs[0]) {
      File f = File(path + "output.c");
      await f.create();
      f.writeAsString(_textControllers[0].text);
    }
    if (selectedLangs[1]) {
      File f = File(path + "output.cpp");
      await f.create();
      f.writeAsString(_textControllers[1].text);
    }
    if (selectedLangs[2]) {
      File f = File(path + "output.java");
      await f.create();
      f.writeAsString(_textControllers[2].text);
    }
    if (selectedLangs[3]) {
      File f = File(path + "output.py");
      await f.create();
      f.writeAsString(_textControllers[3].text);
    }
    if (selectedLangs[4]) {
      File f = File(path + "output.go");
      await f.create();
      f.writeAsString(_textControllers[4].text);
    }
    if (selectedLangs[5]) {
      File f = File(path + "output.dart");
      await f.create();
      f.writeAsString(_textControllers[5].text);
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Done"),
            content: Text("Files Created at $path"),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }
}
