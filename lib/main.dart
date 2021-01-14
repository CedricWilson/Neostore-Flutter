import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/AddressBloc/address_bloc.dart';
import 'package:flutter_neostore/Bloc/CartBloc/cart_bloc.dart';
import 'package:flutter_neostore/Bloc/ProductBloc/product_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_bloc.dart';
import 'package:flutter_neostore/Page/HomePage.dart';

import 'Navigation/routes.dart';

// void main() => runApp(MyApp());
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'NeoStore',
//       home: Home(),
//
//     );
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => WrapperBloc(),
    ),
    BlocProvider(
      create: (context) => ProductBloc(),
    ),
    BlocProvider(
      create: (context) => CartBloc(),
    ),
    BlocProvider(
      create: (context) => AddressBloc(),
    ),
  ],
      child:
      MaterialApp(home: MyApp())
     // MaterialApp(home: Home())
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Varela',
          primaryColor: Color(0xFF30B1F2),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF30B1F2),     //  <-- dark color-- this auto selects the right color
          ),
        textTheme: TextTheme(
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Color(0xFF757575),
        ),
        backgroundColor: Color(0xFFf5f5f5),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutingConstants.wrapper,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
//TEXT COLORS DARK(757575)

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("data"),
      ),
    );
  }
}
