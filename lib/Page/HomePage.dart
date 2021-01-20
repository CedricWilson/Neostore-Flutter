import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_bloc.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_events.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_bloc.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_events.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_events.dart';
import 'package:flutter_neostore/Helpers/SharedPrefs.dart';
import 'package:flutter_neostore/Modal/ResponseCart.dart';
import 'package:flutter_neostore/Modal/User.dart';
import 'package:flutter_neostore/Navigation/Details.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int pos = 0;
  int counter = 0;
  String name = "Name";
  String email = "email";
  String image = "image";

  List data = [
    "assets/slider_bed.jpg",
    "assets/slider_chair.jpg",
    "assets/slider_sofa.jpg",
    "assets/slider_table.jpg"
  ];

  List list = [
    "assets/Beds.jpg",
    "assets/Sofas.jpg",
    "assets/Chairs.jpg",
    "assets/Tables.jpg",
  ];



  count() async {
    ResponseCart cart = await ApiProvider().cart();
    setState(() {
      if (cart.count != null) {
        counter = cart.count;
      }
    });
  }

  userRefresh() async {
    User user = await SharedPrefs().fetchUser();

    if (user != null) {
      setState(() {
        name = user.fname + " " + user.lname;
        email = user.email;
        image = user.image;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    count();
    userRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //print(state);
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    final _key = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/editprofile',
            ).then((value) => userRefresh());
          },
          child: Text(
            "NeoStore",
            style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 3, right: 12.0),
            child: Stack(children: <Widget>[
              new IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 35,
                  ),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/cart');
                    BlocProvider.of<CartBloc>(context).add(CartStarted());
                  }),
              counter != 0
                  ? new Positioned(
                      right: 1,
                      top: 1,
                      child: new Container(
                        padding: EdgeInsets.all(2),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        constraints: BoxConstraints(
                          //TODO
                          minWidth: query(context, 2.5),
                          minHeight: query(context, 2.5),
                        ),
                        child: Text(
                          counter.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width(context, 4),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : new Container()
            ]),
          )
        ],
      ),
      body: ListView(
        children: [pager(context), group()],
      ),
      drawer: drawer(),
    );
  }

  Widget pager(BuildContext context) {
    return Container(
      height: query(context, 36),
      padding: EdgeInsets.only(top: 8.0, left: 7, right: 7, bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        color: Theme.of(context).primaryColor,
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            ClipRRect(
                //TODO
                borderRadius: BorderRadius.circular(15),
                child: Carousel(
                  images: [
                    for (var i in data) Image.asset(i.toString(), width: 180, height: 180, fit: BoxFit.fill),
                  ],
                  dotSize: 13.0,
                  autoplay: false,
                  dotSpacing: 45.0,
                  dotColor: Colors.white,
                  dotIncreaseSize: 1.7,
                  dotVerticalPadding: 10,
                  indicatorBgPadding: 5.0,
                  animationCurve: Curves.fastOutSlowIn,
                  dotBgColor: Colors.transparent,
                  borderRadius: true,
                )),
            // Positioned.fill(
            //   child: Align(
            //     alignment: Alignment.bottomCenter,
            //     child: Padding(
            //       padding: const EdgeInsets.only(bottom: 15.0),
            //       child: CarouselIndicator(
            //         count: 4,
            //         index: pos,
            //         activeColor: Colors.blue,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // )
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
                      child: image == null
                          ? Image.asset('assets/profile.png', width: 100, height: 100, fit: BoxFit.fill)
                          : Image(
                              width: 100,
                              height: 100,
                              image: NetworkImage(image),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Text(
                        name,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Text(email, style: TextStyle(color: Colors.white))
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
            title: Text('Edit Profiles'),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/editprofile',
              ).then((value) => userRefresh());
            },
          ),
          ListTile(
            leading: Icon(
              Icons.map,
              color: Colors.black,
            ),
            title: Text('Store Locator'),
            onTap: () {
              Fluttertoast.showToast(msg: "Under Construction");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.today_outlined,
              color: Colors.black,
            ),
            title: Text('My Orders'),
            onTap: () {
              Navigator.pushNamed(context, '/orders');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return dialogLogout(context);
                  });
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
    Navigator.pushNamed(context, '/products', arguments: i.toString()).then((value) => count());
  }

  Widget dialogLogout(BuildContext context) {
    return AlertDialog(
      //backgroundColor: Colors.pinkAccent,
      elevation: 15.0,
      content: Text("Sure to Logout?"),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
              SharedPrefs().clear();
              BlocProvider.of<WrapperBloc>(context).add(AppStarted());
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            )),
        FlatButton(
            onPressed: () {
              BlocProvider.of<WrapperBloc>(context).add(AppStarted());
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

// CarouselSlider(
//   options: CarouselOptions(
//     height: MediaQuery.of(context).size.height * 0.30,
//     autoPlay: false,
//     viewportFraction: 1,
//     aspectRatio: 2.0,
//     onPageChanged: (index, reason) {
//       setState(() {
//         pos = index;
//       });
//     },
//   ),
//   items: [
//     "assets/slider_bed.jpg",
//     "assets/slider_chair.jpg",
//     "assets/slider_sofa.jpg",
//     "assets/slider_table.jpg"
//   ].map((i) {
//     return Builder(
//       builder: (BuildContext context) {
//         return Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: BoxDecoration(color: Colors.white),
//             child: Image(
//               image: AssetImage(i),
//               fit: BoxFit.fill,
//             ));
//       },
//     );
//   }).toList(),
// ),
