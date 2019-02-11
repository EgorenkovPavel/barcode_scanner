
class ScanException implements Exception {

  final String _title;
  final String _message;

  ScanException(this._title, this._message);

  String get message => _message;

  String get title => _title;

}