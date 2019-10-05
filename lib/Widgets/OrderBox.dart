import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kitchen_orders_status/Brains/Login.dart';
import 'package:kitchen_orders_status/Brains/Orders.dart';
import 'package:provider/provider.dart';

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
    if (widget.status == 'complete') {
      var timestamp = DateTime.parse(widget.timestamp).toLocal();
      setState(() {
        time =
            'เสร็จ: ${timestamp.hour}:${timestamp.minute < 10 ? '0' + timestamp.minute.toString() : timestamp.minute}';
      });
    } else {
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
  }

  submitComplete(orderId, quantity) {
    var ordersBrains = Provider.of<Orders>(context);
    var loginInfo = Provider.of<Login>(context);
    ordersBrains.submitComplete(
        orderId, quantity, loginInfo.id, loginInfo.token);
  }

  submitRedo(orderId) {
    var loginInfo = Provider.of<Login>(context);
    var ordersBrains = Provider.of<Orders>(context);
    ordersBrains.submitRedo(orderId, loginInfo.token);
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
            left: BorderSide(
                width: 10.0,
                color: widget.status == 'complete'
                    ? Colors.green
                    : Colors.red.shade600),
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
                        color: widget.status == 'complete'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 100,
                child: Center(
                  child: widget.status == 'complete'
                      ? RaisedButton(
                          color: Colors.redAccent.shade100,
                          onPressed: () {
                            submitRedo(widget.id);
                          },
                          child: Text('ย้อนกลับ'),
                        )
                      : RaisedButton(
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
