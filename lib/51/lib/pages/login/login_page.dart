// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unused_field, curly_braces_in_flow_control_structures,, unused_element, avoid_print, override_on_non_overriding_member

//import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/51/lib/constants/api.dart';
import 'package:frontend/51/lib/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stock_app/constants/api.dart';
// import 'package:stock_app/models/user.dart';
// import 'package:stock_app/pages/products/products_page.dart';
// import 'package:stock_app/services/network.service.dart';
import 'package:validators/validators.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var user = User();
  var isLogin = false;
  //var password = User();

  @override
  void initState() {
    //
    super.initState();
    _chkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? Products()
        : Scaffold(
            backgroundColor: Colors.blueAccent,
            body: SafeArea(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 500,
                  //width: 500,
                  child: Card(
                    child: _login(),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _login() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _user(),
            _password(),
            SizedBox(
              height: 10,
            ),
            _loginButton(),
            registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _user() => TextFormField(
        initialValue: user.username,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Exam@email.com',
          //labelText: 'Name *',
        ),
        onSaved: (String? value) {
          user.username = value!;
        },
        validator: (String? value) {
          return !isEmail(value!) ? 'Email invalid' : null;
        },
      );

  Widget _password() => TextFormField(
        obscureText: true,
        initialValue: user.password,
        decoration: const InputDecoration(
          icon: Icon(Icons.vpn_key),
          //hintText: 'What do people call you?',
          //labelText: 'Name *',
        ),
        onSaved: (String? value) {
          user.password = value!;
        },
        validator: (String? value) {
          return (value!.length < 5) ? 'aleast 5 character' : null;
        },
      );

  Widget _loginButton() {
    return ElevatedButton.icon(
      //style: Size(width:12, height),
      onPressed: _buildLogin,
      icon: Icon(Icons.login_rounded),
      label: Text('Login'),
    );
  }

  _buildLogin() {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    FocusScope.of(context).requestFocus(FocusNode());

    NetworkService()
        .login(user)
        .then((value) => _goProduct(value))
        .onError((error, stackTrace) => print((error as DioError).message));

    //Navigator.pushNamed(context, '/product');
  }

  Future<void> _showAlert(String value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(value),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(user.username),
                Text(user.password),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _goProduct(String value) async {
    if (value == API.OK) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool(API.ISLOGIN, true);

      Navigator.pushNamed(context, '/product');
    } else {
      _showAlert(value);
    }
  }

  _chkLogin() async {
    var prefs = await SharedPreferences.getInstance();
    var chk = prefs.get(API.ISLOGIN);
    print(chk);
    //if(chk == true) Navigator.pushReplacementNamed(context, '/products');
    setState(() {
      isLogin = chk as bool;
    });
  }

  Widget registerButton() {
    return OutlinedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _confirmRegister();
        }
      },
      child: const Text(
        'Register',
      ),
    );
  }

  void _confirmRegister() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.greenAccent,
        title: const Text('ยืนยันการลงทะเบียน'),
        content: Text('Email : ${user.username}\nPassword: ${user.password}'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'Ok');
              _buildRegister();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _buildRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //ยกเลิกแสดงคีย์บอร์ด
      FocusScope.of(context).requestFocus(FocusNode());
      var result = await NetworkService().Register(user);
      if (result == API.OK) {
        //Navigator.pushNamed(context, '/products');
        var prefs = await SharedPreferences.getInstance();
        prefs.setBool(API.ISLOGIN, true);

        Navigator.pushReplacementNamed(context, '/products');
      } else {
        _showAlert(result);
      }
    }
  }
}
