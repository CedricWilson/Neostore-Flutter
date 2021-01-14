import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_bloc.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_events.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_states.dart';
import 'package:flutter_neostore/Modal/ResponseCart.dart';
import 'package:flutter_neostore/Page/Details.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';


class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  String token = "";
  ResponseCart product;
  List<Data> data;
  bool edited = false;
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
              Icons.keyboard_return_rounded,
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
              print("State: Empty");
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
        ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: <Widget>[
                  IconSlideAction(
                      caption: 'Delete',
                      icon: Icons.delete,
                      color: Colors.red,
                      onTap: () => deleteitem(
                          list[index].productId, index, list[index].product.cost, list[index].quantity)),
                ],
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.only(top: 8.0, bottom: 0, left: 8, right: 8),
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
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                              width: 100,
                              height: 100,
                              image: NetworkImage(list[index].product.productImages),
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
                                    list[index].product.name,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    "Quantity: " + list[index].quantity.toString(),
                                    style: TextStyle(color: Colors.black),
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
                            child: Text("Rs. " + list[index].product.cost.toString(),
                                style: TextStyle(color: Colors.red)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
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
                        "Rs. " + product.total.toString(),
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
                      onPressed: () {},
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

  deleteitem(int productId, int index, int cost, int quantity) {
    BlocProvider.of<CartBloc>(context).add(CartDelete(id: productId));
    setState(() {
      data.removeAt(index);
      product.total = product.total - cost * quantity;
    });
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
}
