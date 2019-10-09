import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kitchen_orders_status/Brains/Login.dart';
import 'package:kitchen_orders_status/Brains/Orders.dart';
import '../constant.dart' as constants;
import 'package:provider/provider.dart';

import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class First extends StatefulWidget {
  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> {
  var _id = "";
  var _passcode = "";
  SocketIO socket;
  SocketIOManager manager = SocketIOManager();
  @override
  void initState() {
    super.initState();
    initSocket();
  }

  handleCallback(status) {
    if (!status) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("เกิดข้อผิดพลาด"),
            content: new Text("ไม่สามารถเชื่อมต่อกับเซิฟเวอร์ได้"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("ปิด"),
                onPressed: () {
                  exit(0);
                },
              ),
            ],
          );
        },
      );
    }
  }

  initSocket() async {
    socket =
        await manager.createInstance(SocketOptions(constants.serverIpAddress,
            query: {
              "auth": "--SOME AUTH STRING---",
              "info": "new connection from adhara-socketio",
              "timestamp": DateTime.now().toString()
            },
            enableLogging: false,
            transports: [Transports.WEB_SOCKET, Transports.POLLING]));
    socket.connect();

    var orders = Provider.of<Orders>(context);
    socket.on('updateOrders', (data) {
      orders.getCookingOrder();
      orders.getCompleteOrder();
      print('UpdateOrders called+++++++++');
    });
  }

  setUserId(userId) {
    socket.emit('setUserId', [userId]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SafeArea(
            child: Scaffold(
      body: Center(
        child: Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'ID'),
                keyboardType: TextInputType.number,
                onChanged: (val) => _id = val,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Passcode'),
                keyboardType: TextInputType.number,
                obscureText: true,
                onChanged: (val) => _passcode = val,
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
              ),
              RaisedButton(
                onPressed: () {
                  print('ID:$_id Passcode:$_passcode');
                  if (_id == "" || _passcode == "") {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "เกิดข้อผิดพลาด",
                      desc: 'กรุณาใส่ ID และ Passcode',
                      buttons: [
                        DialogButton(
                          child: Text(
                            "ปิด",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                        )
                      ],
                    ).show();
                  } else {
                    var ordersInfo = Provider.of<Orders>(context);
                    var loginInfo = Provider.of<Login>(context);
                    loginInfo.logInfo(_id, _passcode, (status, msg) {
                      if (status) {
                        setUserId(msg);
                        ordersInfo.getCookingOrder();
                        ordersInfo.getCompleteOrder();
                        Navigator.pushReplacementNamed(
                            context, '/cooking-orders');
                      } else {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "ไม่สามารถเข้าสู่ระบบได้",
                          desc: msg,
                          buttons: [
                            DialogButton(
                              child: Text(
                                "ปิด",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show();
                      }
                    });
                  }
                },
                child: Text('เข้าสู่ระบบ'),
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
