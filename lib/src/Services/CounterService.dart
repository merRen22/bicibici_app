import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/Counter.dart';

class CounterService {
  AwsSigV4Client awsSigV4Client;
  CounterService(this.awsSigV4Client);

  Future<Counter> getCounter() async {
    final signedRequest =
        new SigV4Request(awsSigV4Client, method: 'GET', path: '/counter');
    final response =
        await http.get(signedRequest.url, headers: signedRequest.headers);
    return new Counter.fromJson(json.decode(response.body));
  }

  Future<Counter> incrementCounter() async {
    final signedRequest =
        new SigV4Request(awsSigV4Client, method: 'PUT', path: '/counter');
    final response =
        await http.put(signedRequest.url, headers: signedRequest.headers);
    return new Counter.fromJson(json.decode(response.body));
  }
}
