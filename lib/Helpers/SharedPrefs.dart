import 'package:flutter_neostore/Modal/ResponseLogin.dart';
import 'package:flutter_neostore/Modal/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  setUser(Data data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('fname', data.firstName);
    prefs.setString('lname', data.firstName);
    prefs.setString('email', data.email);
    prefs.setString('token', data.accessToken);
    prefs.setString('image', data.profilePic);
    prefs.setString('bday', data.dob);
  }

  setUser2(String fname,String lname,String email,String image,String bday, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('fname', fname);
  prefs.setString('lname', lname);
  prefs.setString('email', email);
  prefs.setString('token', token);
  prefs.setString('image', image);
  prefs.setString('bday', bday);
  }

  token() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token') ?? '';
    //print("Shared: " + stringValue);
    return prefs.getString('token') ?? '';
  }

  isLogged() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString('token') ?? '';
    if(value.isEmpty){
      return false;
    }else{
      return true;
    }
  }

  fetchUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return User(
      fname: prefs.getString('fname'),
      lname: prefs.getString('lname'),
      email: prefs.getString('email'),
      token: prefs.getString('token'),
      image: prefs.getString('image'),
      bday: prefs.getString('bday'),
    );
  }

  clear() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
