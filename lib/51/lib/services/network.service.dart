// ignore_for_file: unused_local_variable, non_constant_identifier_names, unused_import, prefer_const_declarations, unnecessary_string_interpolations, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stock_app/constants/api.dart';
import 'package:stock_app/models/product.dart';
import 'package:stock_app/models/user.dart';
import 'package:stock_app/pages/products/products_page.dart';

class NetworkService {
  //สร้างออบแบบ single ton คือจองพื้นที่หน่วยความจำเรียบร้อยแล้ว
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  var dio = Dio()
    ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.baseUrl = API.BASE_URL;
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.next(response);
    }, onError: (DioError e, handler) {
      e.error = 'การเชื่อมต่อผิดพลาด';
      return handler.next(e);
    }));

  Future<String> login(User user) async {
    var url = API.LOGIN;
    //var url = API.BASE_URL+API.LOGIN; ในกรณีไม่ใส่ options.baseUrl
    var logindata = FormData.fromMap({
      'username': user.username,
      'password': user.password,
    });

    var response = await dio.post(url, data: logindata);
    var msg = response.data['msg'];
    return msg;
  }

  Future<String> Register(User user) async {
    final url = API.REGISTER;
    FormData data = FormData.fromMap({
      'username': user.username,
      'password': user.password,
    });
    String msg;
    try {
//Response ท าการ map ผลลัพธ์ให้โดยอัตโนมัติ
      final Response response = await dio.post(url, data: data);
      msg = response.data["msg"];
    } catch (e) {
      msg = 'Network error';
    }
    return msg;
  }

  Future<List<Product>> getProduct() async {
    var url = API.PRODUCT;
    var response = await dio.get(url);
    var data = productFromJson(json.encode(response.data));
    return data;
  }

  Future<String> addProduct(Product product, {File? imageFile}) async {
    final url = API.PRODUCT;

    ///แปลง data เป็น form
    FormData data = FormData.fromMap({
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'stock': product.stock,
      if (imageFile!.path.isNotEmpty) ////ตรวจสอบว่า image มีไฟล์ไหม?
        'upfile': await MultipartFile.fromFile(
          imageFile.path,
//contentType: MediaType('image', 'jpg'),
        )
    });
    String msg;
    try {
//Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
      final Response response = await dio.post(url, data: data);
      msg = response.data["msg"];
    } catch (e) {
      msg = 'Network error';
    }
    return msg;
  }





  Future<String> editProduct(Product product, {File? imageFile}) async {
    final url = API.PRODUCT;

    ///แปลง data เป็น form
    FormData data = FormData.fromMap({
      'id': product.id,
      'name': product.name,
      'price': product.price,
      'stock': product.stock,
      'image' : product.image,
      if (imageFile!.path.isNotEmpty) ////ตรวจสอบว่า image มีไฟล์ไหม?
        'upfile': await MultipartFile.fromFile(
          imageFile.path,
//contentType: MediaType('image', 'jpg'),
        )
    });
    String msg;
    try {
//Response ทำการ map ผลลัพธ์ให้โดยอัตโนมัติ
      final Response response = await dio.put(url, data: data);
      msg = response.data["msg"];
    } catch (e) {
      msg = 'Network error';
    }
    return msg;
  }

  Future<String> deleteProduct(int id) async {
    var url = "${API.PRODUCT}/$id";
    String msg;
    try {
      var response = await dio.delete(url);
      // var result = response.data["result"] as Product;
      // msg = "delete successfully\n ${result.id} ${result.name}";
      msg = "OK";
    } catch (e) {
      msg = 'Network error';
    }
    return msg;

    
  }




}
