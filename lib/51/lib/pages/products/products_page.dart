// ignore_for_file: prefer_const_constructors, unused_local_variable, unused_import

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_app/constants/api.dart';
import 'package:stock_app/models/product.dart';
import 'package:stock_app/services/network.service.dart';

class Products extends StatefulWidget {
  const Products({Key? key}) : super(key: key);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: NetworkService().getProduct(),///เป็นการโหลดจาก api
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var product = snapshot.data as List<Product>;
              return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: _gridView(product));
            }
            if (snapshot.error != null) {
              var err = (snapshot.error as DioError).message;
              return Center(
                child: Text(err),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         await Navigator.pushNamed(context, '/add');
          setState(() {
            
          });
        },
        child: Icon(Icons.add_to_photos_sharp),
      ),
    );
  }

  void _logout() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(API.ISLOGIN);
    Navigator.pushNamed(context, '/');
  }

  Widget _gridView(List<Product> product) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: product.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: _viewProduct(product[index]),
          );
        });
  }

  Widget _viewProduct(Product product) {
    return GestureDetector(////ตรวจสอบการจิ้ม
    onTap: () => Navigator.pushNamed(context, '/edit',arguments: product)
    .then((value) {
      setState(() {});
    }),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "${API.BASE_URL}${product.image}",
            fit: BoxFit.fill,
          ),
          Text(
            "${product.id} ${product.name}",
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                backgroundColor: Colors.blueAccent,
                fontSize: 20),
          ),
          //Text("${product.name}")
        ],
      ),
    );
  }






}
