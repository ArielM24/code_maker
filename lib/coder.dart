import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:code_maker/parser.dart';

Future<List<_Shape>> readJson(File f) async {
  List<Map> shapes = List<Map>();
  String str = await f.readAsString();
  str = '{"shapes":$str}';
  Map<String, dynamic> data = JsonCodec().decode(str);
  data["shapes"].forEach((e) {
    if (e["classList"]["1"] != "line") {
      shapes.add(e);
    }
  });

  return getShapes(shapes);
}

class _Shape {
  String type;
  String id;
  String content;
  @override
  String toString() => "{$type, $id, $content}";
}

class _Line extends _Shape {
  String id1, id2;
  @override
  String toString() => super.toString() + " $id1, $id2";
}

List<_Shape> getShapes(List<Map> shapes) {
  List<_Shape> l = [];
  for (var s in shapes) {
    String type = s["classList"]["1"];
    if (type != "line") {
      l.add(getShape(s));
      print(s["id"] + ":" + s["title"]);
    } else {
      print("line");
      l.add(getLine(s));
      print("l:" + s["title"]);
    }
  }
  return l;
}

_Shape getShape(Map<dynamic, dynamic> shape) {
  _Shape s = _Shape();
  s.type = shape["classList"]["1"];
  s.id = shape["id"];
  s.content = shape["title"];
  return s;
}

_Line getLine(Map<dynamic, dynamic> shape) {
  _Line l = _Line();

  l.type = shape["classList"]["1"];
  l.id = shape["id"];
  l.content = shape["title"];
  l.id1 = shape["classList"]["4"].split("id1")[1];
  l.id2 = shape["classList"]["5"].split("id2")[1];

  return l;
}

String getRaw(List<_Shape> shapes) {
  String raw = "";
  for (_Shape s in shapes) {
    raw += s.content + "\n";
  }
  print(raw);
  return raw;
}

class Coder {
  int ifelse = 0; //1 -> true, 2-> else
  List<_Shape> _shapes;
  String raw = "";
  Coder.build(this._shapes);
  Coder.fromRaw(this._shapes) : raw = getRaw(_shapes);
  String getCodeC() {
    String code = "#include<stdio.h>\n\nint main(){\n";
    for (_Shape s in _shapes) {
      code += getCShape(s);
    }

    return code + "\n\treturn 0;\n}";
  }

  String getCShape(_Shape s) {
    switch (s.type) {
      case "rectangulo":
        String str = '\t${s.content};\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo1":
        String str = inC(s.content);
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo2":
        String str = '\tprintf("${s.content}\\n");\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "rombo":
        ifelse = 1;
        return '\tif(${s.content}){\n\t';
        break;
      default:
        return "";
    }
  }

  String inC(String content) {
    var l = content.split(":");
    String format;
    switch (l[0]) {
      case "int":
        format = "%d";
        break;
      case "float":
        format = "%f";
        break;
    }
    return '\tscanf("$format",&${l[1]});\n';
  }

  String getCodeCpp() {
    String code = "#include<iostream>\nusing namespace std;\nint main(){\n";
    for (_Shape s in _shapes) {
      code += getCppShape(s);
    }

    return code + "\n\treturn 0;\n}";
  }

  String getCppShape(_Shape s) {
    switch (s.type) {
      case "rectangulo":
        String str = '\t${s.content};\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo1":
        String str = "\tcin>>${s.content.split(':')[1]};\n";
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo2":
        String str = '\tcout<<"${s.content}"<<endl;\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "rombo":
        ifelse = 1;
        return '\tif(${s.content}){\n\t';
        break;
      default:
        return "";
    }
  }

  String getCodeJava() {
    String code = "import java.util.Scanner;\n"
        "public class output{\n"
        "\tstatic Scanner scan = new Scanner(System.in);\n"
        "\tpublic static void main(String[] args){\n";
    for (_Shape s in _shapes) {
      code += getJavaShape(s);
    }

    return code + "\n\t}\n}";
  }

  String getJavaShape(_Shape s) {
    switch (s.type) {
      case "rectangulo":
        String str = '\t${s.content};\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo1":
        String str = inJava(s.content);
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo2":
        String str = '\tSystem.out.println("${s.content}");\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "rombo":
        ifelse = 1;
        return '\tif(${s.content}){\n\t';
        break;
      default:
        return "";
    }
  }

  String inJava(String content) {
    var l = content.split(":");
    switch (l[0]) {
      case "int":
        return "\t${l[1]} = scan.nextInt();\n";
        break;
      case "float":
        return "\t${l[1]} = scan.nextFloat();\n";
        break;
      default:
        return "";
    }
  }

  String getCodePython() {
    String code = "if __name__ == '__main__':\n";
    for (_Shape s in _shapes) {
      code += getPythonShape(s);
    }

    return code;
  }

  String getPythonShape(_Shape s) {
    switch (s.type) {
      case "rectangulo":
        String str = '\t${s.content.split(" ")[1]} = 0\n';
        if (ifelse == 1) {
          str += "\n";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "\telse:\n\t\t" + str + "\n";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo1":
        String str = inPython(s.content);
        if (ifelse == 1) {
          str += "\n";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "\telse:\n\t\t" + str + "\n";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo2":
        String str = '\tprint("${s.content}");\n';
        if (ifelse == 1) {
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "\telse:\n\t\t" + str + "\n";
          ifelse = 0;
        }
        return str;
        break;
      case "rombo":
        ifelse = 1;
        return '\tif ${s.content} :\n\t';
        break;
      default:
        return "";
    }
  }

  String inPython(String content) {
    var l = content.split(":");
    switch (l[0]) {
      case "int":
        return "\t${l[1]} = int(input())\n";
        break;
      case "float":
        return "\t${l[1]} = float(intput())\n";
        break;
      default:
        return "";
    }
  }

  String getCodeGo() {
    String code = "package main\n"
        'import "fmt"\n'
        "func main(){\n";
    for (_Shape s in _shapes) {
      code += getGoShape(s);
    }

    return code + "\n}";
  }

  String getGoShape(_Shape s) {
    switch (s.type) {
      case "rectangulo":
        var l = s.content.split(" ");
        String str = '\tvar ${l[1]} ${l[0]};\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo1":
        String str = inGo(s.content);
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo2":
        String str = '\tfmt.Println("${s.content}");\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "rombo":
        ifelse = 1;
        return '\tif ${s.content} {\n\t';
        break;
      default:
        return "";
    }
  }

  String inGo(String content) {
    var l = content.split(":");
    String format;
    switch (l[0]) {
      case "int":
        format = "%d";
        break;
      case "float":
        format = "%f";
        break;
    }
    return '\tfmt.Scanf("$format",&${l[1]});\n';
  }

  String getCodeDart() {
    String code = "import 'dart:io';\n"
        "main(){\n";
    for (_Shape s in _shapes) {
      code += getDartShape(s);
    }

    return code + "\n}";
  }

  String getDartShape(_Shape s) {
    switch (s.type) {
      case "rectangulo":
        var l = s.content.split(" ");
        String str = '\tvar ${l[1]};\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo1":
        String str = inDart(s.content);
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "paralelogramo2":
        String str = '\tprint("${s.content}");\n';
        if (ifelse == 1) {
          str += "\t}";
          ifelse = 2;
        } else if (ifelse == 2) {
          str = "else{\n\t\t" + str + "\t}";
          ifelse = 0;
        }
        return str;
        break;
      case "rombo":
        ifelse = 1;
        return '\tif(${s.content}){\n\t';
        break;
      default:
        return "";
    }
  }

  String inDart(String content) {
    var l = content.split(":");
    String format;
    switch (l[0]) {
      case "int":
        format = "int.parse";
        break;
      case "float":
        format = "float.parse";
        break;
    }
    return '\t${l[1]} = $format(stdin.readLineSync());\n';
  }

  String getFuncC() {
    String code = "";
    List lines = raw.split("\n");
    lines.removeWhere((line) => line.isEmpty);
    print(lines.length);
    for (String line in lines) {
      code += parseCLine(line);
    }
    code = code.replaceAll("nums", "double*");
    code = code.replaceAll("num", "double");
    code = code.replaceAll("none", "void");
    code = code.replaceAll("[", "[(int)");
    return code;
  }

  String getFuncCpp() {
    String code = "";
    List lines = raw.split("\n");
    lines.removeWhere((line) => line.isEmpty);
    print(lines.length);
    for (String line in lines) {
      code += parseCppLine(line);
    }
    code = code.replaceAll("nums", "double*");
    code = code.replaceAll("num", "double");
    code = code.replaceAll("none", "void");
    code = code.replaceAll("[", "[(int)");
    return code;
  }

  String getFuncJava() {
    String code = "";
    List lines = raw.split("\n");
    lines.removeWhere((line) => line.isEmpty);
    print(lines.length);
    for (String line in lines) {
      code += parseJavaLine(line);
    }
    code = code.replaceAll("nums", "double[]");
    code = code.replaceAll("num", "double");
    code = code.replaceAll("none", "void");
    code = code.replaceAll("[", "[(int)");
    code = code.replaceAll("[(int)]", "[]");
    return code;
  }

  String getFuncPython() {
    String code = "";
    List lines = raw.split("\n");
    lines.removeWhere((line) => line.isEmpty);
    print(lines.length);
    for (String line in lines) {
      code += parsePythonLine(line);
    }
    //code = code.replaceAll("nums", "[]");
    code = code.replaceAll("num", "");
    code = code.replaceAll("none", "");
    //code = code.replaceAll("[", "[(int)");
    //code = code.replaceAll("[(int)]", "[]");
    return code;
  }
}
