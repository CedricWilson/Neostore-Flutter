import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Modal/ResponseOrder.dart';

import 'Details.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/homescreen', (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/homescreen', (route) => false),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                print("hi");
              },
            )
          ],
          title: Text(
            "My Orders",
            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Color(0xFFf5f5f5),
        body: FutureBuilder(
            future: ApiProvider().orderlist(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                ResponseOrder data = snapshot.data;

                return renderlist(data);
              }
              if (snapshot.hasError) {
                return Container(
                  width: 0,
                  height: 0,
                );
              }
              print("hi2");
              return CupertinoActivityIndicator();
            }),
      ),
    );
  }

  Widget renderlist(ResponseOrder data) {
    List<Data> list = data.data;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              Navigator.pushNamed(context,'/orderdetail', arguments: list[index].id);
            },
            child: Card(
              elevation: 1,
              margin: EdgeInsets.only(top: 8.0, bottom: 1, left: 8, right: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                height: 100,
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order ID: " + list[index].id.toString(),
                                style: TextStyle(color: Colors.black, fontSize: 23),
                              ),
                              Text(
                                "Ordered Date: " + list[index].created,
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        format(list[index].cost),
                        style: TextStyle(fontSize: 17, color: Colors.red),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
