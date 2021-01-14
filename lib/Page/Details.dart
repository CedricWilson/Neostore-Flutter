import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_bloc.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_events.dart';
import 'package:flutter_neostore/Modal/ResponseDetails.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  final int id;

  Details({Key key, @required this.id}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int price;
  bool pricestate = false;
  int selectedIndex=0;

  final _detailsform = GlobalKey<FormState>();
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
        appBar: AppBar(

          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
                BlocProvider.of<CartBloc>(context).add(CartStarted());
              },
            )
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "NeoStore",
            style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: ApiProvider().details(widget.id),
          builder: (context, AsyncSnapshot<ResponseDetails> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  top(context, snapshot.data.data),
                  middle(context, snapshot.data.data),
                  bottom(context, snapshot.data.data),
                ],
              );
            }
            if (snapshot.hasError) {
              return errorEmpty();
            }
            // print("Details: " + snapshot.data);
            else
              return Center(
                child: CupertinoActivityIndicator(),
              );
          },
        ));
  }

  Widget top(context, data) {
    Data list = data;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        //side: BorderSide(color: Colors.white70, w),
        borderRadius: BorderRadius.circular(1),
      ),
      child: Container(
        height: query(context, 11),
        width: double.infinity,
        // color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0,left:12,right: 12,bottom:6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                list.name,
                style: TextStyle(
                    fontSize: 20,
                ),

              ),
              Text(
                "Category- " + cat(list.productCategoryId),
                style: TextStyle(fontSize: 13),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list.producer,
                    style: TextStyle(fontSize: 16),
                  ),
                  RatingBar.builder(
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    initialRating: list.rating.toDouble(),
                    onRatingUpdate: null,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget middle(BuildContext context, data) {
    Data list = data;

    if (pricestate == false) {
      price = list.cost;
      pricestate = true;
    }

    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.only(top: 16,left:12,right: 12, bottom: 8),
        child: Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        format(price),
                        style: TextStyle(color: Colors.red, fontSize: 25),
                      ),
                      Icon(
                        Icons.share,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      child: Image(
                        width: 300,
                        image: NetworkImage(list.productImages[selectedIndex].image),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:3.0,bottom: 5),
                  child: Container(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: list.productImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: index == selectedIndex
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                    width: 4),
                              ),
                              child: Image(
                                width: 100,
                                image: NetworkImage(list.productImages[index].image),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  "Description",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Text(list.description,style: TextStyle(fontSize: 13),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottom(context, data) {
    Data list = data;

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
          height: query(context, 8),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        String token = prefs.getString('token') ?? '';

                        ApiProvider()
                            .buy(token, list.id.toString(),4.toString())
                            .then((value) {
                          Fluttertoast.showToast(msg: value.userMsg);
                        }).catchError((error, stackTrace) {
                          print('error caught: $error');
                        });

                        // showDialog(
                        //     barrierDismissible: true,
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.all(Radius.circular(32.0))),
                        //
                        //         content: Container(
                        //           child: buyDialogue(context, list),
                        //         ),
                        //       );
                        //
                        //
                        //     });
                        //
                      },
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.grey[350],
                      onPressed: () {
                        setState(() {
                          price = price + 1;
                        });
                      },
                      child: Text(
                        "RATE",
                      )),
                ),
              ],
            ),
          )),
    );
  }

  Widget buyDialogue(BuildContext context, Data list) {
    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20),
            Text(
              list.name,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
            Image(
              width: 300,
              image: NetworkImage(list.productImages[0].image),
              fit: BoxFit.fill,
            ),
            SizedBox(height: 10),
            Text(
              "Quantity:",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Form(
              key: _detailsform,
              child: Column(
                children: [
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: new InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(15.0),
                          ),
                          // width: 0.0 produces a thin "hairline" border
                          borderSide: const BorderSide(color: Colors.blue, width: 2),
                        ),
                        border: const OutlineInputBorder(),
                        labelStyle: new TextStyle(color: Colors.green),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (String value) {
                        int num = 0;
                        if (value.isNotEmpty) {
                          num = int.parse(value);
                        } else {
                          return 'Enter Quantity';
                        }
                        if (num < 1 || num > 7) {
                          return 'Enter value between 1 and 7';
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        quantity = int.parse(value);
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              "BUY",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (!_detailsform.currentState.validate()) {
                                return;
                              }
                              _detailsform.currentState.save();

                              // print(id.toString() + " " + quantity.toString());
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              String token = prefs.getString('token') ?? '';
                              //print(token);
                              // print("hi");

                              ApiProvider()
                                  .buy(token, list.id.toString(), quantity.toString())
                                  .then((value) {
                                print(value.userMsg);
                              }).catchError((error, stackTrace) {
                                print('error caught: $error');
                              });

                              Navigator.pop(context);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            color: Colors.grey[350],
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "CANCEL",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                //  SizedBox(height: 10),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  String cat(int productCategoryId) {
    switch (productCategoryId) {
      case 1:
        return "Table";
        break;
      case 2:
        return "Chairs";
        break;
      case 3:
        return "Sofas";
        break;
      case 4:
        return "Beds";
        break;
    }
    return "NULL";
  }

  Widget errorEmpty() {
    return Center(
      child: Text("No Internet"),
    );
  }
}

query(BuildContext context, int i) {
  double k = i / 100;
  return MediaQuery.of(context).size.height * k;
}

String format(int price){
  var format = NumberFormat.currency(locale: 'HI');
  String str = format.format(price);
  str = "Rs. "+str.substring(3, str.length - 3);

  return str;
}