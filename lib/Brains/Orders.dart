import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

const serverIpAddress = 'http://192.168.1.55:2222/';

class Orders with ChangeNotifier {
  var cookingOrders = [];

  getCookingOrder() async {
    print('Cooking orderssss');
    try {
      var url =
          '${serverIpAddress}api/restaurant/tables/order-status/get-cooking-order';
      var response = await http.get(url);
      var body = json.decode(response.body);
      body.sort((a, b) {
        var aTime = DateTime.parse(a['timestamp']);
        var bTime = DateTime.parse(b['timestamp']);
        return aTime.compareTo(bTime);
      });
      this.cookingOrders = body;
      notifyListeners();
      print('Update nofitey get COoking');
    } catch (error) {
      print(error);
      print('Chatch errror');
    }
  }

  submitComplete(orderId, quantity, userId, token) async {
    print('SubmitComplete');
    try {
      var url = '${serverIpAddress}api/restaurant/tables/order-status/add';
      var response = await http.post(url, headers: {
        'AUTHENTICATION': token
      }, body: {
        'item_order_id': orderId,
        'status': 'complete',
        'create_by': userId,
        'quantity': quantity.toString()
      });
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        print(body['msg']);
      } else {
        print(body['msg']);
      }
    } catch (error) {
      print(error);
    }
  }
}
