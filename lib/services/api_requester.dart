import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:refuelings_collector/constants.dart';
import 'package:refuelings_collector/models/refueling.dart';
import 'package:refuelings_collector/models/refuelings.dart';
import 'package:refuelings_collector/models/user.dart';

class ApiRequester {
  final _storage = FlutterSecureStorage();

  Future<User> attemptSignIn(String email, String password) async {
    User user;
    String body = json.encode({
      'email': email,
      'password': password,
    });

    http.Response resp = await http.post(
      Uri.parse(Constants.signInUrl),
      headers: Constants.defaultHeaders,
      body: body,
    );
    if (resp.statusCode == 200) {
      _storeHeaders(resp.headers);

      var jsonString = resp.body;
      user = userFromJson(jsonString);
    } else {
      print('The response status is: ${resp.statusCode}');
      print('The response body is: ${resp.body}');
    }

    return user;
  }

  Future<User> validateToken() async {
    User user;

    http.Response resp = await http.get(
      Uri.parse(Constants.validateUrl),
      headers: await _buildReqHeaders(),
    );

    if (resp.statusCode == 200) {
      _storeHeaders(resp.headers);

      var jsonString = resp.body;
      user = userFromJson(jsonString);
    } else {
      print('The response status is: ${resp.statusCode}');
      print('The response body is: ${resp.body}');
    }

    return user;
  }

  Future signOut() async {
    http.Response resp = await http.delete(
      Uri.parse(Constants.signOutUrl),
      headers: await _buildReqHeaders(),
    );

    if (resp.statusCode == 200) {
      _clearStoreHeaders();
    } else {
      print('The response status is: ${resp.statusCode}');
      print('The response body is: ${resp.body}');
    }
  }

  Future<Refuelings> getRefuelings() async {
    Refuelings refuelings;

    http.Response resp = await http.get(Uri.parse(Constants.refuelingsUrl),
        headers: await _buildReqHeaders());
    if (resp.statusCode == 200) {
      _storeHeaders(resp.headers);
      var jsonString = resp.body;
      refuelings = refuelingsFromJson(jsonString);
    } else {
      print('The response status is: ${resp.statusCode}');
      print('The response body is: ${resp.body}');
    }

    return refuelings;
  }

  Future<String> createRefueling(Refueling refueling) async {
    String _message;
    String _body = json.encode(refueling.toJson());

    http.Response resp = await http.post(Uri.parse(Constants.refuelingsUrl),
        headers: await _buildReqHeaders(), body: _body);
    if (resp.statusCode == 200) {
      _message = 'success';
    } else {
      _message = jsonDecode(resp.body)['message'].join('\n');
      print('The response status is: ${resp.statusCode}');
      print('The response body is: ${resp.body}');
    }
    _storeHeaders(resp.headers);

    return _message;
  }

  Future<String> updateRefueling(Refueling refueling) async {
    String _message;
    String _body = json.encode(refueling.toJson());

    http.Response resp = await http.patch(
        Uri.parse('${Constants.refuelingsUrl}/${refueling.id}'),
        headers: await _buildReqHeaders(),
        body: _body);
    if (resp.statusCode == 200) {
      _message = 'success';
    } else {
      _message = jsonDecode(resp.body)['message'].join('\n');
      print('The response status is: ${resp.statusCode}');
      print('The response body is: ${resp.body}');
    }
    _storeHeaders(resp.headers);

    return _message;
  }

  Future<String> deleteRefueling(Refueling refueling) async {
    String _message;

    http.Response resp = await http.delete(
        Uri.parse('${Constants.refuelingsUrl}/${refueling.id}'),
        headers: await _buildReqHeaders());
    if (resp.statusCode == 200) {
      _message = 'success';
    } else {
      _message = jsonDecode(resp.body)['message'].join('\n');
      print('The response status is: ${resp.statusCode}');
      print('The response body is: ${resp.body}');
    }
    _storeHeaders(resp.headers);

    return _message;
  }

  void _storeHeaders(Map<String, String> headers) async {
    // if access-token and expiry are empty strings, that means API treated request
    // as batch request and those values should not be updated
    if (headers['access-token'].isNotEmpty && headers['expiry'].isNotEmpty) {
      await _storage.write(
        key: 'access-token',
        value: headers['access-token'],
      );
      await _storage.write(
        key: 'expiry',
        value: headers['expiry'],
      );
    }
    await _storage.write(
      key: 'client',
      value: headers['client'],
    );
    await _storage.write(
      key: 'uid',
      value: headers['uid'],
    );
  }

  void _clearStoreHeaders() {
    ['access-token', 'client', 'expiry', 'uid'].forEach(
      (key) async => await _storage.delete(key: key),
    );
  }

  Future<Map<String, String>> _buildReqHeaders() async {
    Map<String, String> headers = {
      ...Constants.defaultHeaders,
      'Token-Type': 'Bearer',
      'access-token': await _storage.read(key: 'access-token'),
      'client': await _storage.read(key: 'client'),
      'expiry': await _storage.read(key: 'expiry'),
      'uid': await _storage.read(key: 'uid'),
    };

    return headers;
  }
}
