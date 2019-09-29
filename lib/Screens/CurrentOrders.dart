import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_orders_status/Brains/Login.dart';
import 'package:provider/provider.dart';
import './../Brains/Orders.dart';

class CurrentOrders extends StatefulWidget {
  @override
  _CurrentOrdersState createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
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
              AppHeader(),
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
                  ),
                  FlatButton(
                    child: Text(
                      'ปรุงเสร็จ',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade400,
                  child: orders.cookingOrders.length != 0
                      ? ListView(
                          children: getCurrentOrders(orders.cookingOrders),
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

class AppHeader extends StatefulWidget {
  @override
  _AppHeaderState createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'รายการที่กำลังทำ',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              var loginInfo = Provider.of<Login>(context);
              loginInfo.logout(() {
                Navigator.pushReplacementNamed(context, '/login-screen');
              });
            },
            child: Text(
              'ออกจากระบบ',
              style: TextStyle(
                  color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
          SizedBox(
            width: 30.0,
          )
        ],
      ),
    );
  }
}

class OrderBox extends StatefulWidget {
  final String id;
  final String tableNumber;
  final String name;
  final String shortName;
  final int quantity;
  final String status;
  final String timestamp;
  final String fromTable;

  const OrderBox(
      {Key key,
      this.id,
      this.tableNumber,
      this.name,
      this.quantity,
      this.status,
      this.timestamp,
      this.shortName,
      this.fromTable})
      : super(key: key);
  @override
  _OrderBoxState createState() => _OrderBoxState();
}

class _OrderBoxState extends State<OrderBox> {
  var time = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.showTime();
  }

  showTime() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        var unformatedSecond = DateTime.now()
            .difference(DateTime.parse(widget.timestamp))
            .inSeconds;
        var second = unformatedSecond % 60 < 10
            ? '0${unformatedSecond % 60}'
            : unformatedSecond % 60;
        var minute = ((unformatedSecond / 60) % 60).toInt() < 10
            ? '0${((unformatedSecond / 60) % 60).toInt()}'
            : ((unformatedSecond / 60) % 60).toInt();
        var hour = (unformatedSecond / (60 * 60)).toInt() < 10
            ? '0${(unformatedSecond / (60 * 60)).toInt()}'
            : (unformatedSecond / (60 * 60)).toInt();
        setState(() {
          time = 'เวลา: $hour:$minute:$second';
        });
      }
    });
  }

  submitComplete(orderId, quantity) {
    var ordersBrains = Provider.of<Orders>(context);
    var loginInfo = Provider.of<Login>(context);
    ordersBrains.submitComplete(
        orderId, quantity, loginInfo.id, loginInfo.token);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 10.0, color: Colors.red.shade600),
          ),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey,
              offset: new Offset(3.0, 5.0),
              blurRadius: 5,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 120,
                child: RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'โต๊ะ: ',
                      ),
                      widget.fromTable != null
                          ? TextSpan(
                              text: '${widget.fromTable}',
                              style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.lineThrough))
                          : TextSpan(
                              text: '${widget.tableNumber}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                      widget.fromTable != null
                          ? TextSpan(
                              text: ' ${widget.tableNumber}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : TextSpan()
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Text(
                    '${widget.name}',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                  width: 80,
                  child: new RichText(
                    text: new TextSpan(
                      // Note: Styles for TextSpans must be explicitly defined.
                      // Child text spans will inherit styles from parent
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                          text: 'Qty: ',
                          style: new TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new TextSpan(
                          text: '${widget.quantity}',
                        ),
                      ],
                    ),
                  )),
              Container(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'รับโดย: ${widget.shortName}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                child: Center(
                  child: RaisedButton(
                    color: Colors.greenAccent,
                    onPressed: () {
                      submitComplete(widget.id, widget.quantity);
                    },
                    child: Text('ปรุงเสร็จ'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
