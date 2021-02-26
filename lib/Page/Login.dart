import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_bloc.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_events.dart';
import 'package:flutter_neostore/Bloc/WrapperBloc/wrapper_states.dart';
import 'package:flutter_neostore/Helpers/SharedPrefs.dart';
import 'package:flutter_neostore/Modal/ResponseLogin.dart';
import 'package:flutter_neostore/Navigation/routes.dart';
import 'package:flutter_neostore/Page/HomePage.dart';
import 'package:flutter_neostore/Page/Registration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  TextEditingController _defemail = new TextEditingController();
  TextEditingController _defpass = new TextEditingController();
  String token;

  void register() async {
    final result = await Navigator.push(
      context,
      PageTransition(type: PageTransitionType.scale,duration: Duration(milliseconds: 700), alignment: Alignment.bottomRight, child: Registration()),
    );

    try {
      List list = result.values.toList();
      print(list[0]);
      _defemail.text = list[0];
      _defpass.text = list[1];
    } catch (e) {}
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _key,
      // appBar: AppBar(
      //   title: Text("Login"),
      //   centerTitle: true,
      // ),
      body: ListView(
        children: [
          Column(
            children: [
              top(),
              middle(),
            ],
          ),
        ],
      ),
      floatingActionButton: registerfloat(),
    );
  }

  top() {
    return Padding(
      padding: const EdgeInsets.only(top: 120, bottom: 40),
      child: Text(
        "NeoStore",
        style: TextStyle(fontSize: 40),
      ),
    );
  }

  middle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
        key: _formKey,
        child:
        Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                  controller: _defemail,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Email is Required';
                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$123%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Incorrect Email Type';
                    } else
                      return null;
                  },
                  onSaved: (String value) {
                    _email = value;
                  },
                  keyboardType: TextInputType.emailAddress),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.lock),
                  hintText: 'Enter your password',
                  labelText: 'Password',
                ),
                controller: _defpass,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Password is Required';
                  } else if (value.length < 6) {
                    return 'Minimum size is 6 characters';
                  } else
                    return null;
                },
                onSaved: (String value) {
                  _password = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 38.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.blue)),
                    color: Colors.blue,
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      _formKey.currentState.save();

                      print(_email + " " + _password);

                      ApiProvider().login(_email, _password).then((val) {
                        if (val.status.toString() == "200") {

                          Data data = val.data;
                          SharedPrefs().setUser(data);
                          Fluttertoast.showToast(msg: "Login Successful");
                          BlocProvider.of<WrapperBloc>(context).add(LoginSuccess());

                        }
                      }).catchError((error, stackTrace) {
                        print('error caught: $error');
                        Fluttertoast.showToast(msg: error.toString());
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  registerfloat() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          register();
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Registration()));
         // Navigator.pushNamed(context, '/signup');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
