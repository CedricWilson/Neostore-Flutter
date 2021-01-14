import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/AddressBloc/address_bloc.dart';
import 'package:flutter_neostore/Bloc/AddressBloc/address_events.dart';
import 'package:flutter_neostore/Bloc/AddressBloc/address_states.dart';
import 'package:flutter_neostore/Database/database.dart';
import 'package:flutter_neostore/Page/Details.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Orders.dart';

class Address extends StatefulWidget {
  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final _detailsform = GlobalKey<FormState>();
  String address;
  String email;
  String name = "hi";
  int selectedindex;
  String selectedaddress = "null";

  @override
  Widget build(BuildContext context) {
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
              BlocProvider.of<AddressBloc>(context).add(AddressStarted());
            },
          )
        ],
        title: Text(
          "Address",
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFf5f5f5),
      body: BlocConsumer<AddressBloc, AddressStates>(
        listener:  (context,states){
          if(states is OrderSuccess){
            // print("state: Auth Initial");
            Navigator.pushNamedAndRemoveUntil(context, '/homescreen/orders', (route) => false);
            push();
          }
        },
        builder: (context, state) {
          if (state is AddressInitial) {
            BlocProvider.of<AddressBloc>(context).add(AddressStarted());
          } else if (state is AddressSuccessful) {
            name = state.fname;
            email = state.email;
            return adresslist(state.task);
          } else if(state is AddressEmpty) {
            return adressEmpty();
          }
          return Center(child: CupertinoActivityIndicator());
        },
      ),
      floatingActionButton: fab(),
    );
  }

  Widget adresslist(List<Task> list) {
    return Stack(
      children: [
        Positioned.fill(top: 10, left: 10, child: Text("Shipping Address:")),
        Positioned.fill(
          top: 35,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 5, left: 6, right: 6),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedindex = index;
                        selectedaddress = list[index].address;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border: Border.all(
                            color: index == selectedindex ? Theme.of(context).primaryColor : Colors.white,
                            width: 6),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style:
                                  TextStyle(fontSize: 20, color: Color(0xFF757575), fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(list[index].address),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ButtonTheme(
              height: query(context, 6),
              minWidth: query(context, 30),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                onPressed: () {
                  print("Pre-Order: " + selectedaddress + " " + email);
                  if (selectedindex == null || selectedaddress == null) {
                    Fluttertoast.showToast(msg: "Select an Address");
                  } else {
                    print("Address: "+selectedaddress);
                    BlocProvider.of<AddressBloc>(context).add(Order(address: selectedaddress));
                  }
                },
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  fab() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add),
      onPressed: () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                content: Container(
                  child: buyDialogue(context),
                ),
              );
            });
      },
    );
  }

  Widget buyDialogue(BuildContext context) {
    return Wrap(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: 20),
            Text(
              "Address",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 30),
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
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter Address';
                        } else
                          return null;
                      },
                      onSaved: (String value) {
                        address = value;
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
                              "ADD",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (!_detailsform.currentState.validate()) {
                                return;
                              }
                              _detailsform.currentState.save();

                              final task = new Task(address: address, email: email);

                              BlocProvider.of<AddressBloc>(context).add(AddressAdd(address: task));

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

  Widget adressEmpty() {
    return Center(
      child: Text("Address is Empty"),
    );
  }

  void push() {
    Navigator.pushNamed(context, '/orders');
  }
}
