
abstract class NetworkService {
 
  Future<dynamic> get(String url, {Map<String, dynamic>? queries});
  
}

class AppException implements Exception {
  AppException(this.prefix, this.message);

  final dynamic prefix;
  final dynamic message;
}

class FetchDataException extends AppException {
  FetchDataException(message) : super("Error during communication: ", message);
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super("Unauthorised: ", message);
}

class ServerErrorException extends AppException {
  ServerErrorException([
    String message =
        "Oh no! We encountered an error and our technical staff have been automatically notified and will be looking into this with the utmost urgency.",
  ]) : super("Notice", message);
}

class GeneralErrorException extends AppException {
  GeneralErrorException([
    String message =
        "Oh no! We encountered an error and our technical staff have been automatically notified and will be looking into this with the utmost urgency.",
  ]) : super("Notice", message);
}
