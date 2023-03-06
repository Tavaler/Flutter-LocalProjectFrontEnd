// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
    Product({
         this.id=0,
         this.name="",
         this.image="",
         this.price=0,
         this.stock=0,
    });

    int id;
    String name;
    String image;
    int price;
    int stock;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        image: json["image"] ??'', //== null ? null : json["image"],ถ้าไม่มีค่าimageให้เป็นค่า " " ว่าง
        price: json["price"],
        stock: json["stock"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,// == null ? null : image,
        "price": price,
        "stock": stock,
    };
}
