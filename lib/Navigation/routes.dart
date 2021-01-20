import 'package:flutter/material.dart';
import 'package:flutter_neostore/Page/Address.dart';
import 'package:flutter_neostore/Page/Cart.dart';
import 'package:flutter_neostore/Page/Details.dart';
import 'package:flutter_neostore/Page/EditProfile.dart';
import 'package:flutter_neostore/Page/HomePage.dart';
import 'package:flutter_neostore/Page/Login.dart';
import 'package:flutter_neostore/Page/OrderDetail.dart';
import 'package:flutter_neostore/Page/Orders.dart';
import 'package:flutter_neostore/Page/ProductList.dart';
import 'package:flutter_neostore/Page/Registration.dart';
import 'package:flutter_neostore/wrapper.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var data = settings.arguments;
    switch (settings.name) {
      case RoutingConstants.home:
        return MaterialPageRoute(builder: (_) => Home());
      case RoutingConstants.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RoutingConstants.register:
        return MaterialPageRoute(builder: (_) => Registration());
      case RoutingConstants.wrapper:
        return MaterialPageRoute(builder: (_) => Wrapper());
      case RoutingConstants.products:
        String id = settings.arguments;
        return PageTransition(
            child: ProductsList(id: id), type: PageTransitionType.size, alignment: Alignment.center);
      case RoutingConstants.details:
        int id = settings.arguments;
        return PageTransition(
            child: Details(id: id),
            type: PageTransitionType.rightToLeftWithFade,
            duration: Duration(milliseconds: 400));
      case RoutingConstants.cart:
        return PageTransition(
            child: Cart(), type: PageTransitionType.topToBottom);
      case RoutingConstants.address:
        return PageTransition(
            child: Address(), type: PageTransitionType.rightToLeft);
      case RoutingConstants.orders:
        return PageTransition(
            child: Orders(), type: PageTransitionType.rightToLeft);
      case RoutingConstants.editprofile:
        return MaterialPageRoute(builder: (_) => EditProfile());
      case RoutingConstants.orderdetail:
        int id = settings.arguments;
        return MaterialPageRoute(builder: (_) => OrderDetailsPage(id: id));
    }
  }
}

class RoutingConstants {
  static const String login = "/login";
  static const String register = "/signup";
  static const String home = "/homescreen";
  static const String wrapper = "/wrapperscreen";
  static const String products = "/products";
  static const String details = "/details";
  static const String cart = "/cart";
  static const String address = "/address";
  static const String orders = "/orders";
  static const String orderdetail = "/orderdetail";
  static const String editprofile = "/editprofile";
}
