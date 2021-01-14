import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_states.dart';
import 'package:flutter_neostore/Page/HomePage.dart';
import 'package:flutter_neostore/Page/Login.dart';
import 'package:flutter_neostore/Page/splash_screen.dart';

import 'Bloc/WrapperBloc/wrapper_events.dart';
import 'Navigation/routes.dart';


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WrapperBloc, WrapperStates>(
        listener:  (context,states){
          if(states is WrapInitial){
           // print("state: Auth Initial");
            BlocProvider.of<WrapperBloc>(context).add(AppStarted());
          }
        },
        builder: (context, states){// ignore: missing_return
          if(states is WrapInitial){
            //print("Building AuthInitial");
            BlocProvider.of<WrapperBloc>(context).add(AppStarted());
           // print("Splash");

            return SplashScreen();
          }
          if(states is AuthSuccessful){
           // print("AuthSuccessful");
            return Home();
          }
          if(states is UnAuthState){
          //  print("UnAuthState");
            return LoginScreen();
          }
        }

    );
  }
}
