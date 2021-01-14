import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/AddressBloc/address_bloc.dart';
import 'package:flutter_neostore/Bloc/AddressBloc/address_events.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_bloc.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_events.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_bloc.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_events.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_events.dart';
import 'package:flutter_neostore/Helpers/SharedPrefs.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pos = 0;

  List list = [
    "assets/Beds.jpg",
    "assets/Sofas.jpg",
    "assets/Chairs.jpg",
    "assets/Tables.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/orders');
          },
          child: Text(
            "NeoStore",
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
              BlocProvider.of<CartBloc>(context).add(CartStarted());
              // showDialog(
              //   barrierDismissible: false,
              //   context: context,
              //   builder: (context){
              //     return dialogLogout(context);
              //   });

            },
          )
        ],
      ),
      body: ListView(
        children: [pager(), group()],
      ),
      drawer: drawer(),
    );
  }

  Widget pager() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10, right: 10),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          //side: BorderSide(color: Colors.white70, w),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.30,
                  autoPlay: false,
                  viewportFraction: 1,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      pos = index;
                    });
                  },
                ),
                items: [
                  "assets/slider_bed.jpg",
                  "assets/slider_chair.jpg",
                  "assets/slider_sofa.jpg",
                  "assets/slider_table.jpg"
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Image(
                            image: AssetImage(i),
                            fit: BoxFit.fill,
                          ));
                    },
                  );
                }).toList(),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: CarouselIndicator(
                    count: 4,
                    index: pos,
                    activeColor: Colors.blue,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget group() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          for (var i in list)
            InkWell(
              onTap: () {
                tapprocess(i.toString());
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.asset(i.toString(), width: 180, height: 180, fit: BoxFit.fill),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: Text(
                      format(i.toString()),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 240,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.asset('assets/profile.png', width: 100, height: 100, fit: BoxFit.fill),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Text(
                        "Name",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text("email", style: TextStyle(color: Colors.white))
                  ],
                )),
          ),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            title: Text('My Cart'),
            onTap: () {
              // Fluttertoast.showToast(msg: "null");
              //showDialog(context);
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.table,
              color: Colors.black,
            ),
            title: Text('Tables'),
            onTap: () {
              Fluttertoast.showToast(msg: "null");
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.couch,
              color: Colors.black,
            ),
            title: Text('Sofas'),
            onTap: () {
              Fluttertoast.showToast(msg: "null");
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.chair,
              color: Colors.black,
            ),
            title: Text('Tables'),
            onTap: () {
              Fluttertoast.showToast(msg: "null");
            },
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.addressCard,
              color: Colors.black,
            ),
            title: Text('Cupboard'),
            onTap: () {
              Fluttertoast.showToast(msg: "null");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.black,
            ),
            title: Text('Account'),
            onTap: () {
              Fluttertoast.showToast(msg: "null");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.black,
            ),
            title: Text('Store Locator'),
            onTap: () {
              Fluttertoast.showToast(msg: "null");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.today_outlined,
              color: Colors.black,
            ),
            title: Text('My Orders'),
            onTap: () {
              Fluttertoast.showToast(msg: "null");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: Text('Logout'),
            onTap: () {
              //showLogoutDialogue(context);
              SharedPrefs().clear();
              BlocProvider.of<WrapperBloc>(context).add(AppStarted());
            },
          ),
        ],
      ),
    );
  }

  String format(String string) {
    return string.substring(7, string.length - 4);
  }

  void tapprocess(String string) {
    string = format(string);
    switch (string) {
      case "Beds":
        furniture(4);
        break;
      case "Chairs":
        furniture(2);
        break;
      case "Sofas":
        furniture(3);
        break;
      case "Tables":
        furniture(1);
        break;
    }
    // print(format(string));
  }

  void furniture(int i) {
    // print("Furniture: "+i.toString());
    BlocProvider.of<ProductBloc>(context).add(ProductStarted(id: i.toString()));
    Navigator.pushNamed(context, '/products', arguments: i.toString());
  }

  Widget dialogLogout(BuildContext context) {
    return AlertDialog(
      //backgroundColor: Colors.pinkAccent,
      elevation: 15.0,
      content: Text("Sure to Logout?"),
      actions: [
        FlatButton(
            onPressed: () {
              SharedPrefs().clear();
              BlocProvider.of<WrapperBloc>(context).add(AppStarted());
              Navigator.pop(context);
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {
              //BlocProvider.of<HomeBloc>(context).add(HomeLogoutPressed());
              Navigator.pop(context);
            },
            child: Text(
              "No",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  void kshowDialog(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            height: 300,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      // transitionBuilder: (_, anim, __, child) {
      //   return SlideTransition(
      //     position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
      //     child: child,
      //   );
      // },
    );
  }
}
