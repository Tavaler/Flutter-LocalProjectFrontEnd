////LOGIN
//import 'package:ecommerce_int2/app_properties.dart';
// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace, unused_field, unnecessary_const, unused_element, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app_properties.dart';
import 'package:frontend/constants/api.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/page/login/register.dart';
import 'package:frontend/services/network.service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

//import 'register_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var user = User();
  var isLogin = false;

    @override
  void initState() {
    //
    super.initState();
    _chkLogin();
  }

  // TextEditingController email =
  //     TextEditingController(text: 'example@email.com');

  // TextEditingController password = TextEditingController(text: '12345678');

  @override
  Widget build(BuildContext context) {

    ///หัวข้อ
    Widget welcomeBack = Text(
      'Welcome Back Roberto,',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          // ignore: prefer_const_literals_to_create_immutables
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    //คำบรรยาย
    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Login to your account using\nMobile number ดเดกเเ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));


    ///ปุ่ม Login
    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => Register()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 80,
          child: Center(
              child: new Text("Log In",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 20.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  // ignore: prefer_const_literals_to_create_immutables
                  colors: [
                    Color.fromRGBO(236, 60, 3, 1),
                    Color.fromRGBO(234, 60, 3, 1),
                    Color.fromRGBO(216, 78, 16, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );


    ///form login
    Widget loginForm = Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: UserEmail,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: UserPassword,
                    style: TextStyle(fontSize: 16.0),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Forgot your password? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {},
            child: Text(
              'Reset password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );

      Widget _user() => TextFormField(
        initialValue: user.UserEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: 'Exam@email.com',
          //labelText: 'Name *',
        ),
        onSaved: (String? value) {
          user.UserEmail = value!;
        },
        validator: (String? value) {
          return !isEmail(value!) ? 'Email invalid' : null;
        },
      );

  Widget _password() => TextFormField(
        obscureText: true,
        initialValue: user.UserPassword,
        decoration: const InputDecoration(
          icon: Icon(Icons.vpn_key),
          //hintText: 'What do people call you?',
          //labelText: 'Name *',
        ),
        onSaved: (String? value) {
          user.UserPassword = value!;
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
        .then((value) => goProduct(value))
        .onError((error, stackTrace) => print((error as DioError).message));

    //Navigator.pushNamed(context, '/product');
  }

   goProduct(String value) async {
    if (value == API.OK) {
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool(API.ISLOGIN, true);

      Navigator.pushNamed(context, '/product');
    } else {
      showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(value),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(user.UserEmail),
                Text(user.UserPassword),
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
                Text(user.UserEmail),
                Text(user.UserPassword),
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

    
    ////การจัดหน้า
    return Scaffold(

      body: Stack(
        children: <Widget>[

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover)
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: transparentYellow,

            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 3),
                welcomeBack,
                Spacer(),
                subTitle,
                Spacer(flex: 2),
                loginForm,
                Spacer(flex: 2),
                forgotPassword
              ],
            ),
          )
        ],
      ),
    );
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
}
