import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  dynamic _returnResponse(http.Response response) {
    try {
      _processResponse(response);
    } on AppException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    int statusCode = response.statusCode;

    try {
      switch (statusCode) {
        //400 ERROR CASES
        case 400:
          throw FetchDataException(processError(response));
        case 401:
          throw UnauthorisedException(processError(response));
        case 402:
          throw GeneralErrorException(processError(response));
        case 403:
          throw UnauthorisedException(json.decode(processError(response)));
        case 404:
          throw GeneralErrorException(processError(response));
        case 405:
          throw GeneralErrorException(processError(response));
        case 406:
          throw GeneralErrorException(processError(response));
        case 408:
          throw GeneralErrorException(processError(response));
        case 409:
          throw GeneralErrorException(processError(response));
        case 410:
          throw GeneralErrorException(processError(response));
        case 421:
          throw GeneralErrorException(processError(response));
        case 422:
          throw GeneralErrorException(processError(response));
        case 423:
          throw GeneralErrorException(processError(response));
        case 424:
          throw GeneralErrorException(processError(response));
        case 425:
          throw GeneralErrorException(processError(response));
        case 426:
          throw GeneralErrorException(processError(response));
        case 429:
          throw GeneralErrorException(processError(response));

        // 500 ERROR CASES
        case 500:
          throw ServerErrorException(processError(response));
        case 501:
          throw GeneralErrorException(processError(response));
        case 502:
          throw GeneralErrorException(processError(response));
        case 503:
          throw GeneralErrorException(processError(response));
        case 504:
          throw GeneralErrorException(processError(response));
        case 505:
          throw GeneralErrorException(processError(response));
        case 506:
          throw GeneralErrorException(processError(response));
        case 507:
          throw GeneralErrorException(processError(response));
        case 508:
          throw GeneralErrorException(processError(response));
        case 509:
          throw GeneralErrorException(processError(response));
        case 510:
          throw GeneralErrorException(processError(response));
        case 511:
          throw GeneralErrorException(processError(response));

        default:
          if (!_isResponseOK(statusCode)) {
            throw FetchDataException(processError(response));
          }
          final responseJson = jsonDecode(response.body);
          return responseJson;
      }
    } catch (e) {
      throw GeneralErrorException(processError(response));
    }
  }

  bool _isResponseOK(int statusCode) {
    return statusCode >= 200 && statusCode <= 209;
  }

  dynamic processError(http.Response response) {
    return jsonDecode(response.body)["message"] ??
        jsonDecode(response.body)["error"]["message"] ??
        jsonDecode(response.body)["error"]["fields"] ??
        jsonDecode(response.body)["error"]["code"];
  }
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
