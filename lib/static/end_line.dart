enum EndLine {
  cr,
  lf,
  crlf,
}

extension EndLineExtension on EndLine {
  String get chars {
    switch (this) {
      case EndLine.cr:
        return "\r";
      case EndLine.lf:
        return "\n";
      case EndLine.crlf:
        return "\r\n";
    }
  }
}