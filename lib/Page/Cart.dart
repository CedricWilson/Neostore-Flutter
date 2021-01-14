import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_bloc.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_events.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_states.dart';
import 'package:flutter_neostore/Modal/ResponseCart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:intl/intl.dart';

import 'Details.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with SingleTickerProviderStateMixin {
  String token = "";
  ResponseCart product;
  List<Data> data;
  bool edited = false;
  int peritem;
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Future<void> _pullRefresh() async {
    BlocProvider.of<CartBloc>(context).add(CartStarted());
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<CartBloc>(context).add(CartStarted());
            },
          )
        ],
        title: Text(
          "Cart",
          style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: BlocBuilder<CartBloc, CartStates>(
          builder: (context, state) {
            if (state is CartInitial) {
              print("State: Initial");
              loading();
              BlocProvider.of<CartBloc>(context).add(CartStarted());
            } else if (state is CartSuccessful) {
              if (edited == false) {
                product = state.cart;
                data = product.data;
                return cartlist(data);
              }
              return cartlist(data);
            } else if (state is CartLoading) {
              //  print("State: Loading");
              return loading();
            } else if (state is CartEmpty) {
              return cartEmpty();
            }
            print("State: Error");
            return networkerror();
          },
        ),
      ),
    );
  }

  Widget cartlist(List<Data> list) {
    return Stack(
      children: [
        AnimatedList(
          key: listKey,
          initialItemCount: list.length,
          itemBuilder: (context, index, animation) => buildItem(context, index, list[index], animation),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Divider(height: 1),
              Container(
                height: query(context, 7),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total:", style: TextStyle(fontSize: 23)),
                      Text(
                        format(product.total),
                        style: TextStyle(color: Colors.red, fontSize: 23),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Theme.of(context).textTheme.bodyText2.color,
                thickness: 1,
              ),
              Container(
                height: query(context, 8),
                width: double.infinity,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 30, right: 30),
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.pushNamed(context, '/address');
                      },
                      child: Text(
                        "CONTINUE",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildItem(BuildContext context, int index, Data list, Animation<double> animation) {
    peritem = list.product.cost*list.quantity;
    return SizeTransition(
      sizeFactor: animation,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
              caption: 'Delete',
              icon: Icons.delete,
              color: Colors.red,
              onTap: () => removeLastItem(
                  list, index, list.productId, list.product.cost, list.quantity, product.data.length)),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Card(
            elevation: 2,
            //margin: EdgeInsets.only(top: 8.0, bottom: 1, left: 8, right: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: 120,
              padding: EdgeInsets.all(10),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image(
                        width: 100,
                        height: 100,
                        image: NetworkImage(list.product.productImages),
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
                              list.product.name,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Category: " + list.product.productCategory,
                              style: TextStyle(fontSize: 12),
                            ),
                            DropdownButton<String>(
                              items: <String>['1', '2', '3', '4', '5', '6', '7', '8'].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              underline: Container(
                                height: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                              value: list.quantity.toString(),
                              // value: list.quantity.toString(),
                              onChanged: (String newValue) {
                                setState(() {
                                  list.quantity = int.parse(newValue);
                                  cartupdate(list, list.productId, int.parse(newValue), list.product.cost);
                                });
                              },
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
                      child: Text(format(peritem), style: TextStyle(color: Colors.red)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void cartupdate(Data list, int productId, int parse, int cost) async {
    BlocProvider.of<CartBloc>(context).add(CartUpdate(id: productId, quantity: parse));
  }

  void removeLastItem(Data list, int index, int productId, int cost, int quantity, int size) {
    listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) => buildItem(context, index, list, animation),
      duration: const Duration(milliseconds: 400),
    );
    setState(() {
      data.removeAt(index);
      product.total = product.total - cost * quantity;
    });
    BlocProvider.of<CartBloc>(context).add(CartDelete(id: productId, index: size));
  }

  Widget networkerror() {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            "No Internet, Pull to Refresh",
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget cartEmpty() {
    return Center(
      child: Text(
        "Cart is Empty",
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey[400]),
      ),
    );
  }

  String format(int price) {
    var format = NumberFormat.currency(locale: 'HI');
    String str = format.format(price);
    str = "Rs. " + str.substring(3, str.length - 3);

    return str;
  }
}
