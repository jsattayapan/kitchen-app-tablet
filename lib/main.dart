import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './Screens/CurrentOrders.dart';
import './Screens/CompleteOrders.dart';
import './Brains/Orders.dart';
import './Brains/Login.dart';
import 'Screens/First.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => Orders()),
        ChangeNotifierProvider(builder: (_) => Login()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/login-screen': (context) => First(),
          '/cooking-orders': (context) => CurrentOrders(),
          '/complete-orders': (context) => CompleteOrders(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return First();
  }
}
