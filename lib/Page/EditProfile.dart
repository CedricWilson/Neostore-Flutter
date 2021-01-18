import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neostore/Api/apiprovider.dart';
import 'package:flutter_neostore/Helpers/SharedPrefs.dart';
import 'package:flutter_neostore/Modal/ResponseEditProfile.dart';
import 'package:flutter_neostore/Modal/ResponseLogin.dart' as login;
import 'package:flutter_neostore/Modal/User.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  String token;
  String image = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";
  String _firstname;
  String _lastname;
  String _email;
  String _phone;
  String _birthday;
  DateTime date;
  File editimage;
  bool edit = false;
  String upimage = "";

  final picker = ImagePicker();

  TextEditingController _defday = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetcher();
  }

  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();
    _defday = new TextEditingController();
  }

  fetcher() async {
    User user = await SharedPrefs().fetchUser();
    if (user != null) {
      setState(() {
        token = user.token;
        if (user.image != null && user.image.length > 0) {
          image = user.image;
        }
        if (user.bday != null) {
          _defday.text = user.bday;
          _birthday = user.bday;
        }
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    // print("Path: "+pickedFile.path);

    final bytes = await pickedFile.readAsBytes();

    setState(() {
      if (pickedFile != null && bytes.length > 0) {
        editimage = File(pickedFile.path);
        edit = true;
        upimage = "data:image/jpg;base64,${base64Encode(editimage.readAsBytesSync())}";
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 50,
          ),
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(90.0),
                child: InkWell(
                  onTap: () {
                    print("Tapped");
                    getImage();
                  },
                  child: Image(
                    width: 180,
                    height: 180,
                    image: edit == false ? NetworkImage(image) : FileImage(editimage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
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
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Last Name is Required';
                  } else
                    return null;
                },
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
              TextFormField(
                decoration: const InputDecoration(
                  icon: const Icon(Icons.cake),
                  hintText: 'Enter your Phone Number',
                  labelText: 'Birthday',
                ),
                controller: _defday,
                onTap: () async {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());

                  final datePick = await showDatePicker(
                      context: context,
                      initialDate: new DateTime.now(),
                      firstDate: new DateTime(1900),
                      lastDate: new DateTime(2100));
                  if (datePick != null && datePick != date) {
                    setState(() {
                      date = datePick;

                      // put it here
                      _birthday = "${date.day}-${date.month}-${date.year}"; // 08/14/2019
                      _defday.text = _birthday;
                    });
                    print(_birthday);
                  }
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

                      if (edit == true) {
                        ApiProvider()
                            .editprofile(_firstname, _lastname, _email, _phone, upimage, _birthday)
                            .then((val) {
                          if (val.status.toString() == "200") {
                            Data data = val.data;

                            SharedPrefs().setUser2(data.firstName,data.lastName,data.email,data.profilePic,data.dob,data.accessToken);
                            Navigator.pushNamedAndRemoveUntil(context, '/homescreen', (route) => false);
                            Fluttertoast.showToast(msg: val.userMsg);
                          }
                        }).catchError((error, stackTrace) {
                          print('error caught: $error');
                          Fluttertoast.showToast(msg: error.toString());
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Edit Image");
                      }
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
