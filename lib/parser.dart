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
    return 'scanf("%f", &${data[2]});';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < ${data[2]}; i_i++) {\n\t\tscanf("%lf", &${data[3]}[i_i]);\n\t}\n';
  }
  return "";
}

String printC(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return 'printf("%lf", &${data[2]});';
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
  return "\t$line {\n\n";
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
    return 'cin>>${data[2]};';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < ${data[2]}; i_i++) {\n\t\tcin>>${data[3]}[i_i];\n\t}\n';
  }
  return "";
}

String printCpp(String line) {
  var data = line.split(" ");
  if (data[1] == "num") {
    return 'cout<<${data[2]}<<endl;';
  } else if (data[1] == "nums") {
    return '\tfor(int i_i = 0; i_i < sizeof ${data[2]} / sizeof *${data[2]}; i_i++)'
        ' {\n\t\tcout<<${data[2]}[i_i]<<endl;\n\t}\n\tcout<<endl;\n';
  }
  return "";
}
