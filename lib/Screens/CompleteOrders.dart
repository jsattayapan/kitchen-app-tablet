import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_orders_status/Brains/Login.dart';
import 'package:kitchen_orders_status/Widgets/AppHeader.dart';
import 'package:kitchen_orders_status/Widgets/OrderBox.dart';
import 'package:provider/provider.dart';
import './../Brains/Orders.dart';

class CompleteOrders extends StatefulWidget {
  @override
  _CompleteOrdersState createState() => _CompleteOrdersState();
}

class _CompleteOrdersState extends State<CompleteOrders> {
  List<Widget> getCurrentOrders(items) {
    List<Widget> list = new List();
    for (var item in items) {
      list.add(
        OrderBox(
          id: item['id'],
          tableNumber: item['table_number'],
          name: item['name'],
          shortName: item['short_name'],
          quantity: item['quantity'],
          status: item['status'],
          timestamp: item['timestamp'],
          fromTable: item['from_table'],
        ),
      );
    }
    return list;
  }

  List<Widget> getCompleteOrders(items) {
    List<Widget> list = new List();
    for (var item in items) {
      list.add(
        OrderBox(
          id: item['id'],
          tableNumber: item['table_number'],
          name: item['name'],
          shortName: item['short_name'],
          quantity: item['quantity'],
          status: item['status'],
          timestamp: item['timestamp'],
          fromTable: item['from_table'],
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    print('build Current');
    var orders = Provider.of<Orders>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppHeader(
                label: 'รายการปรุงเสร็จแล้ว',
              ),
              Row(
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'กำลังปรุง',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/cooking-orders');
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'ปรุงเสร็จ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/complete-orders');
                    },
                  )
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade400,
                  child: orders.completeOrders.length != 0
                      ? ListView(
                          children: getCurrentOrders(orders.completeOrders),
                        )
                      : Center(
                          child: Text('ไม่มีรายการ'),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
