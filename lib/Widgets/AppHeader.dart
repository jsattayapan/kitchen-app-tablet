import 'package:flutter/material.dart';
import 'package:kitchen_orders_status/Brains/Login.dart';
import 'package:provider/provider.dart';

class AppHeader extends StatelessWidget {
  final String label;

  AppHeader({this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
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
