// ignore_for_file: non_constant_identifier_names

class User{
  late String UserEmail;
  late String UserPassword;

  User({this.UserEmail='aaa@gmail.com',this.UserPassword='12345'});
}

// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

// import 'dart:convert';

// List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

// String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class User {
//     User({
//         required this.userId,
//         required this.userFirstname,
//         required this.userLastname,
//         required this.userEmail,
//         required this.userPassword,
//         required this.userPhone,
//         required this.titleId,
//         this.title,
//         required this.cart,
//     });

//     int userId;
//     String userFirstname;
//     String userLastname;
//     String userEmail;
//     String userPassword;
//     String userPhone;
//     int titleId;
//     dynamic title;
//     List<dynamic> cart;

//     factory User.fromJson(Map<String, dynamic> json) => User(
//         userId: json["userId"],
//         userFirstname: json["userFirstname"],
//         userLastname: json["userLastname"],
//         userEmail: json["userEmail"],
//         userPassword: json["userPassword"],
//         userPhone: json["userPhone"],
//         titleId: json["titleId"],
//         title: json["title"],
//         cart: List<dynamic>.from(json["cart"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "userId": userId,
//         "userFirstname": userFirstname,
//         "userLastname": userLastname,
//         "userEmail": userEmail,
//         "userPassword": userPassword,
//         "userPhone": userPhone,
//         "titleId": titleId,
//         "title": title,
//         "cart": List<dynamic>.from(cart.map((x) => x)),
//     };
// }
