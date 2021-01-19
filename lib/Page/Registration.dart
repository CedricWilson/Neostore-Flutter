import 'package:flutter/material.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  String _firstname;
  String _lastname;
  String _email;
  String _password = "123456";
  String _confirm;
  String _phone = "37373772";
  bool _agree = false;
  String _gender = "Male";

  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _gender = "Male";
          break;
        case 1:
          _gender = "Female";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Register",
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Column(
            children: [
              renderform(),
            ],
          ),
        ],
      ),
    );
  }

  renderform() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 40),
      child: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your First Name',
                  labelText: 'First Name',
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'First Name is Required';
                  } else
                    return null;
                },
                onSaved: (String value) {
                    _firstname = value;

                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Enter your Last Name',
                  labelText: 'Last Name',
                ),

                onSaved: (String value) {
                   _lastname = value;

                },
              ),
              TextFormField(
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.email),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Email is Required';
                    } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  icon: const Icon(Icons.lock),
                  hintText: 'Confirm password',
                  labelText: 'Confirm Password',
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Confirm Password is Required';
                  } else if (value.length < 6) {
                    return 'Minimum size is 6 characters';
                  } else if (value != _password) {
                    return 'Passwords should match';
                  } else
                    return null;
                },
                onSaved: (String value) {
                    _confirm = value;

                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10),
                child: Row(
                  children: [
                    Text(
                      "Gender: ",
                      style: TextStyle(fontSize: 17),
                    ),
                    Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text(
                      'M',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: _handleRadioValueChange,
                    ),
                    Text(
                      'F',
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.phone),
                  hintText: 'Enter your Phone Number',
                  labelText: 'Phone',
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Phone is Required';
                  } else
                    return null;
                },
                onSaved: (String value) {
                  _phone = value;
                },
                keyboardType: TextInputType.number,
              ),
              CheckboxListTile(
                title: Text("Agree to User Agreement"),
                value: _agree,
                onChanged: (newValue) {
                  setState(() {
                    _agree = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
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
                      if (_agree == false) {
                        final snackBar = SnackBar(content: Text("Please accept the Agreement"));
                        _key.currentState.showSnackBar(snackBar);
                        return;
                      }
                      _formKey.currentState.save();


                      ApiProvider()
                          .register(_firstname, _lastname, _email, _password, _confirm, _phone, _gender)
                          .then((val) {
                        Fluttertoast.showToast(
                          msg: val.userMsg,
                        );

                        if (val.status == 200) {
                          print("tets");
                          final data = {"email": _email, "password": _password};
                          Navigator.pop(context, data);
                        }
                      }).catchError((error, stackTrace) {
                        Fluttertoast.showToast(
                          msg: error.toString(),
                        );
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
}
