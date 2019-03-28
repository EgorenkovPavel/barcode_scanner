
class ScanException implements Exception {

  final ExceptionType _type;

  ScanException(this._type);

  ExceptionType get type => _type;

}

enum ExceptionType{
  NO_CONNECTION, CONNECTION_ERROR, SERVER_ERROR, UNKNOWN_ERROR, NOT_FOUND
}