import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_states.dart';
import 'package:flutter_neostore/Page/HomePage.dart';
import 'package:flutter_neostore/Page/Login.dart';
import 'package:flutter_neostore/Page/splash_screen.dart';

import 'Bloc/WrapperBloc/wrapper_events.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WrapperBloc, WrapperStates>(listener: (context, states) {
      if (states is WrapInitial) {
        // print("state: Auth Initial");
        BlocProvider.of<WrapperBloc>(context).add(AppStarted());
      }
      // ignore: missing_return
    }, builder: (context, states) {

      if (states is WrapInitial) {
        BlocProvider.of<WrapperBloc>(context).add(AppStarted());
        return SplashScreen();
      }
      if (states is AuthSuccessful) {
      //  print("AuthSuccessful");
        return Home();
      }
      if (states is UnAuthState) {
       // print("UnAuthState");
        return LoginScreen();
      }
    });
  }
}
