import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:figure_the_brand/services/network_service/network_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkServices implements NetworkService {
 late http.Client client;
  String? accessToken;
  bool showError = false;


  NetworkServices({
    http.Client? client,
    this.accessToken,
    this.showError = true,
  })  : client = client ?? http.Client();



 @override
  Future get(String url, {Map<String, dynamic>? queries}) async{
    var responseJson;
    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 60));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw TimeoutException("Connection Timed Out");
    }
    return responseJson;
  } 



  dynamic _returnResponse(http.Response response) {
    try {
      _processResponse(response);
    } on AppException catch (e) {
      if (kDebugMode) {
        print(e.message);
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
          throw FetchDataException(_processError(response));
        case 401:
          throw UnauthorisedException(_processError(response));
        case 402:
          throw GeneralErrorException(_processError(response));
        case 403:
          throw UnauthorisedException(json.decode(_processError(response)));
        case 404:
          throw GeneralErrorException(_processError(response));
        case 405:
          throw GeneralErrorException(_processError(response));
        case 406:
          throw GeneralErrorException(_processError(response));
        case 408:
          throw GeneralErrorException(_processError(response));
        case 409:
          throw GeneralErrorException(_processError(response));
        case 410:
          throw GeneralErrorException(_processError(response));
        case 421:
          throw GeneralErrorException(_processError(response));
        case 422:
          throw GeneralErrorException(_processError(response));
        case 423:
          throw GeneralErrorException(_processError(response));
        case 424:
          throw GeneralErrorException(_processError(response));
        case 425:
          throw GeneralErrorException(_processError(response));
        case 426:
          throw GeneralErrorException(_processError(response));
        case 429:
          throw GeneralErrorException(_processError(response));

        // 500 ERROR CASES
        case 500:
          throw ServerErrorException(_processError(response));
        case 501:
          throw GeneralErrorException(_processError(response));
        case 502:
          throw GeneralErrorException(_processError(response));
        case 503:
          throw GeneralErrorException(_processError(response));
        case 504:
          throw GeneralErrorException(_processError(response));
        case 505:
          throw GeneralErrorException(_processError(response));
        case 506:
          throw GeneralErrorException(_processError(response));
        case 507:
          throw GeneralErrorException(_processError(response));
        case 508:
          throw GeneralErrorException(_processError(response));
        case 509:
          throw GeneralErrorException(_processError(response));
        case 510:
          throw GeneralErrorException(_processError(response));
        case 511:
          throw GeneralErrorException(_processError(response));

        default:
          if (!_responseOK(statusCode)) {
            throw FetchDataException(_processError(response));
          }
          final responseJson = jsonDecode(response.body);
          return responseJson;
      }
    } catch (e) {
      throw GeneralErrorException(_processError(response));
    }
  }

  bool _responseOK(int statusCode) {
    return statusCode >= 200 && statusCode <= 209;
  }

  dynamic _processError(http.Response response) {
    return jsonDecode(response.body)['message'] ??
        jsonDecode(response.body)['error']['message'] ??
        jsonDecode(response.body)['error'];
  }
}