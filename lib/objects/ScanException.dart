import 'package:meta/meta.dart';

class ScanException implements Exception {

  final ExceptionType _type;
  final String _barcode;

  ScanException({@required ExceptionType type, String barcode = ''}) : _type = type, _barcode = barcode;

  ExceptionType get type => _type;

  String get barcode => _barcode;

}

enum ExceptionType{
  NO_CONNECTION, CONNECTION_ERROR, SERVER_ERROR, UNKNOWN_ERROR, NOT_FOUND, WRONG_FORMAT
}