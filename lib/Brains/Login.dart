import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constant.dart' as constants;

class Login with ChangeNotifier {
  var number;
  var name;
  var shortName;
  var position;
  var id;
  var token;

  logInfo(number, passcode, callback) async {
    var url = '${constants.serverIpAddress}api/users/staffs/login';
    try {
      var response = await http.post(url, body: {
        'number': number,
        'passcode': passcode,
        'platform': 'mobile-app-checker'
      });
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        this.number = jsonData['number'];
        this.shortName = jsonData['short_name'];
        this.position = jsonData['position'];
        this.id = jsonData['id'];
        this.token = jsonData['token'];
        notifyListeners();
        callback(true, jsonData['id']);
      } else {
        callback(false, jsonData['msg']);
      }
    } catch (error) {
      print('Erro: $error');
      callback(false, 'ไม่สามารถเชื่อมต่อกับเซิฟเวอร์ได้');
    }
  }

  logout(callback) async {
    callback();
    var url = '${constants.serverIpAddress}api/users/staffs/logout';
    try {
      await http.post(url, body: {
        'id': this.id,
      });
    } catch (error) {
      print('Error: $error');
    }
  }
}
