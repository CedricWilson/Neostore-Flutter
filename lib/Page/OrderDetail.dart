import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Modal/ResponseOrder.dart';
import 'package:flutter_neostore/Modal/ResponseOrderDetail.dart';

import 'Details.dart';

class OrderDetailsPage extends StatefulWidget {
  final int id;

  OrderDetailsPage({Key key, @required this.id}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetailsPage> {
  int cost = 0;
  String title="Order";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Color(0xFFf5f5f5),
      body: FutureBuilder(
          future: ApiProvider().orderdetail(widget.id.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              ResponseOrderDetail data = snapshot.data;
              cost = data.data.cost;
              WidgetsBinding.instance.addPostFrameCallback((_){
                setState(() {
                  title =  "Order Id: "+data.data.id.toString();
                });
              });
              return renderlist(data.data.orderDetails);
            }
            if (snapshot.hasError) {
              return Container(
                width: 0,
                height: 0,
              );
            }
            return Center(child: CupertinoActivityIndicator());
          }),
    );
  }
  Widget renderlist(List<OrderDetails > list) {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
            height: query(context, 15),
            padding: EdgeInsets.all(10),

            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[400],)),
            ),
            //padding: EdgeInsets.symmetric(vertical: 5),
            child: Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image(
                      width: 100,
                      height: 100,
                      image: NetworkImage(list[index].prodImage),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            list[index].prodName,
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            "("+list[index].prodCatName+")",
                            style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 20,),
                          Text(
                            "Quantity: "+list[index].quantity.toString(),
                            style: TextStyle(fontSize: 12,fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(format(list[index].total), style: TextStyle(color: Colors.red)),
                  ),
                )
              ],
            ),
          );
        });
  }


}
