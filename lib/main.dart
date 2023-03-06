// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:material/material.dart';
import 'package:frontend/page/login/login.dart';

import 'page/product/product.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _routes = {
      '/': (context) => Login(),
      '/product': (context) => Products(),
      // '/add': (context) => AddProduct(),
      // '/edit': (context) => EditProduct(),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: _routes,
    );
  }
}