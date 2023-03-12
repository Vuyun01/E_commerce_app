// ignore_for_file: public_member_api_docs, sort_constructors_first
class HttpException implements Exception {
  String message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
