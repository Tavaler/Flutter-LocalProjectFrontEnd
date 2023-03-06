// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stock_app/pages/login/login_page.dart';
import 'package:stock_app/pages/products/add_product.dart';
import 'package:stock_app/pages/products/edit_product.dart';
import 'package:stock_app/pages/products/products_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _routes = {
      '/': (context) => Login(),
      '/product': (context) => Products(),
      '/add': (context) => AddProduct(),
      '/edit': (context) => EditProduct(),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: _routes,
    );
  }
}
