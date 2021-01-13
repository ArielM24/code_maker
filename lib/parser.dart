String parseCLine(String line) {
  if (line.startsWith("get")) {
    return scanC(line);
  } else if (line.startsWith("print")) {
    return printC(line);
  } else if (line.startsWith("while")) {
    return whileC(line);
  } else if (line.startsWith("end")) {
    return endC(line);
  } else if (line.startsWith("if")) {
    return ifC(line);
  } else if (line.endsWith(")")) {
    return nameC(line);
  } else if (line.contains(RegExp(r"nums\ ([a-zA-Z]+|[0-9]+)\ [a-zA-Z]+.*"))) {
    return arrayC(line);
  } else
    return "\t$line;\n";
}

String scanC(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return '\tscanf("%f", &${data[2]});';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < ${data[2]}; i_i++) {\n\t\tscanf("%lf", &${data[3]}[i_i]);\n\t}\n';
  }
  return "";
}

String printC(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return '\tprintf("%lf", &${data[2]});';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < sizeof ${data[2]} / sizeof *${data[2]}; i_i++)'
        ' {\n\t\tprintf("%lf\\n", ${data[2]}[i_i]);\n\t}\n\tputs("");\n';
  }
  return "";
}

String whileC(String line) {
  return "\t$line {\n\t";
}

String endC(String line) {
  if (!line.contains("func")) return "\t}\n";
  return "}\n";
}

String ifC(String line) {
  return "\t$line {\n\t";
}

String nameC(String line) {
  return "$line {\n";
}

String arrayC(String line) {
  var data = line.split(" ");
  return "\tdouble ${data[2]}[${data[1]}];\n";
}

String parseIndex(String line) {
  return line.replaceAll("[", "[(int)");
}

String parseCppLine(String line) {
  if (line.startsWith("get")) {
    return scanCpp(line);
  } else if (line.startsWith("print")) {
    return printCpp(line);
  } else if (line.startsWith("while")) {
    return whileC(line);
  } else if (line.startsWith("end")) {
    return endC(line);
  } else if (line.startsWith("if")) {
    return ifC(line);
  } else if (line.endsWith(")")) {
    return nameC(line);
  } else if (line.contains(RegExp(r"nums\ ([a-zA-Z]+|[0-9]+)\ [a-zA-Z]+.*"))) {
    return arrayC(line);
  } else
    return "\t$line;\n";
}

String scanCpp(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return '\tcin>>${data[2]};';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < ${data[2]}; i_i++) {\n\t\tcin>>${data[3]}[i_i];\n\t}\n';
  }
  return "";
}

String printCpp(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return '\tcout<<${data[2]}<<endl;';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < sizeof ${data[2]} / sizeof *${data[2]}; i_i++)'
        ' {\n\t\tcout<<${data[2]}[i_i]<<endl;\n\t}\n\tcout<<endl;\n';
  }
  return "";
}

String parseJavaLine(String line) {
  if (line.startsWith("get")) {
    return scanJava(line);
  } else if (line.startsWith("print")) {
    return printJava(line);
  } else if (line.startsWith("while")) {
    return whileC(line);
  } else if (line.startsWith("end")) {
    return endC(line);
  } else if (line.startsWith("if")) {
    return ifC(line);
  } else if (line.endsWith(")")) {
    return nameJava(line);
  } else if (line.contains(RegExp(r"nums\ ([a-zA-Z]+|[0-9]+)\ [a-zA-Z]+.*"))) {
    return arrayJava(line);
  } else
    return "\t$line;\n";
}

String scanJava(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return '\t${data[2]} = new Scanner(System.in).nextDouble();';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < ${data[2]}; i_i++) {'
        '\n\t\t${data[3]}[i_i] = new Scanner(System.in).nextDouble();\n\t}\n';
  }
  return "";
}

String printJava(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return '\tSystem.out.println(${data[2]});';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < ${data[2]}.length; i_i++)'
        ' {\n\t\tSystem.out.println(${data[2]}[i_i]);\n\t}\n\tSystem.out.println();\n';
  }
  return "";
}

String nameJava(String line) {
  return "public static $line {\n";
}

String arrayJava(String line) {
  var data = line.split(" ");
  return "\tdouble ${data[2]}[] = new double[${data[1]}];\n";
}

String parsePythonLine(String line) {
  if (line.startsWith("get")) {
    return scanPython(line);
  } else if (line.startsWith("print")) {
    return printPython(line);
  } else if (line.startsWith("while")) {
    return whilePython(line);
  } else if (line.startsWith("end")) {
    return endPython(line);
  } else if (line.startsWith("if")) {
    return ifPython(line);
  } else if (line.endsWith(")")) {
    return namePython(line);
  } else if (line.contains(RegExp(r"nums\ ([a-zA-Z]+|[0-9]+)\ [a-zA-Z]+.*"))) {
    return arrayPython(line);
  } else
    return "\t$line\n";
}

String scanPython(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return '\t${data[2]} = float(input())';
  } else if (data[1] == "nums") {
    return '\tfor i_i in range(${data[2]}):\n\t\t${data[3]} = float(input())\n\t}\n';
  }
  return "";
}

String printPython(String line) {
  var data = line.split(" ");
  return "print(${data[2]})";
}

String whilePython(String line) {
  return "\t$line:\n\t";
}

String endPython(String line) {
  return "\n";
}

String ifPython(String line) {
  return "\t$line:\n\t";
}

String namePython(String line) {
  var data = line.split(" ");
  data.removeAt(0);
  print(data);
  return "def ${data.join('')}:\n";
}

String arrayPython(String line) {
  var data = line.split(" ");
  return "\t${data[2]} = [0] * ${data[1]}\n";
}
