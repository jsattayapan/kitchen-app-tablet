import 'package:flutter/material.dart';

class CurrentOrders extends StatefulWidget {
  @override
  _CurrentOrdersState createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppHeader(),
              Expanded(
                child: Container(
                  child: GridView.count(
                    crossAxisCount: 8,
                    children: new List<Widget>.generate(16, (index) {
                      return new GridTile(
                        child: new Card(
                            color: Colors.blue.shade200,
                            child: new Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    'โต๊ะ: 3',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    '3 x ข้าวผัดไก่',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    '** ไม่เผ็ด',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '12.30',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            )),
                      );
                    }),
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
          Container(
            width: 100,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.green,
            ),
            child: GestureDetector(
              child: Center(
                  child: Text(
                'ปรุงเสร็จ',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
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
  @override
  _OrderBoxState createState() => _OrderBoxState();
}

class _OrderBoxState extends State<OrderBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlueAccent.shade200,
      child: Column(
        children: <Widget>[
          Text('3'),
          Text('3 x ข้าวผัดไก่'),
          Text('** ไม่เผ็ด'),
        ],
      ),
    );
  }
}
