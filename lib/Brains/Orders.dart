import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../constant.dart' as constants;

class Orders with ChangeNotifier {
  var cookingOrders = [];
  var completeOrders = [];

  getCookingOrder() async {
    print('Cooking orderssss');
    try {
      var url =
          '${constants.serverIpAddress}api/restaurant/tables/order-status/get-cooking-order/ครัวกลาง';
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

  getCompleteOrder() async {
    print('Cooking orderssss');
    try {
      var url =
          '${constants.serverIpAddress}api/restaurant/tables/order-status/get-complete-order/ครัวกลาง';
      var response = await http.get(url);
      var body = json.decode(response.body);
      body.sort((a, b) {
        var aTime = DateTime.parse(a['timestamp']);
        var bTime = DateTime.parse(b['timestamp']);
        return bTime.compareTo(aTime);
      });
      this.completeOrders = body;
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
      var url =
          '${constants.serverIpAddress}api/restaurant/tables/order-status/add';
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

  submitRedo(orderId, token) async {
    try {
      var url =
          '${constants.serverIpAddress}api/restaurant/tables/order-status/delete-complete';
      var response = await http
          .post(url, headers: {'AUTHENTICATION': token}, body: {'id': orderId});
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
