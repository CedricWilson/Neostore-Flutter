
import 'package:flutter/material.dart';
import 'package:flutter_neostore/Page/Address.dart';
import 'package:flutter_neostore/Page/Cart.dart';
import 'package:flutter_neostore/Page/Details.dart';
import 'package:flutter_neostore/Page/HomePage.dart';
import 'package:flutter_neostore/Page/Login.dart';
import 'package:flutter_neostore/Page/OrderDetail.dart';
import 'package:flutter_neostore/Page/Orders.dart';
import 'package:flutter_neostore/Page/ProductList.dart';
import 'package:flutter_neostore/Page/Registration.dart';
import 'package:flutter_neostore/wrapper.dart';

class Routes{


  static Route<dynamic> generateRoute(RouteSettings settings){
    var data = settings.arguments;
       switch(settings.name){
         case RoutingConstants.home:
              return MaterialPageRoute(builder: (_)=> Home());
         case RoutingConstants.login:
           return MaterialPageRoute(builder: (_)=> LoginScreen());
         case RoutingConstants.register:
           return MaterialPageRoute(builder: (_)=> Registration());
         case RoutingConstants.wrapper:
           return MaterialPageRoute(builder: (_)=> Wrapper());
          case RoutingConstants.products:
           String id = settings.arguments;
           return MaterialPageRoute(builder: (_)=> ProductsList(id: id));
         case RoutingConstants.details:
           int id = settings.arguments;
           return MaterialPageRoute(builder: (_)=> Details(id: id));
          case RoutingConstants.cart:
            return MaterialPageRoute(builder: (_)=> Cart());
         case RoutingConstants.address:
           return MaterialPageRoute(builder: (_)=> Address());
         case RoutingConstants.orders:
           return MaterialPageRoute(builder: (_)=> Orders());
         case RoutingConstants.orderdetail:
           int id = settings.arguments;
           return MaterialPageRoute(builder: (_)=> OrderDetailsPage(id: id));
       }
  }
}
class RoutingConstants{
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
}
