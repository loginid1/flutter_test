class CodeTypeException implements Exception {
  String invalidCodeType;

  CodeTypeException(this.invalidCodeType);

  @override
  String toString() {
    return "'${this.invalidCodeType}' is not a valid code type";
  }
}

class ErrorResponseException implements Exception {
  String message;

  ErrorResponseException(this.message);

  @override
  String toString() {
    return this.message;
  }
}
