class DataException implements Exception {
  String _message;
  int _errorCode;
  static int errorUnknown = -1;

  DataException(this._message, this._errorCode);

  String toString() {
    return _message;
  }

  int getErrorCode() {
    return _errorCode;
  }
}
