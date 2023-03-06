// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print, unused_import, unused_field, prefer_final_fields, avoid_web_libraries_in_flutter, unused_local_variable


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stock_app/constants/api.dart';
import 'package:stock_app/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_app/pages/products/products_page.dart';
import 'package:stock_app/services/network.service.dart';
import 'package:validators/validators.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var product = Product();
  File _imageFile = File('');
  final _picker = ImagePicker();

  //final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.amber[800],
          padding: EdgeInsets.all(10),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [_form(), _image()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          inputId(),
          SizedBox(
            height: 5,
          ),
          _inputName(),
          SizedBox(
            height: 5,
          ),
          _inputPrice(),
          SizedBox(
            height: 5,
          ),
          _inputStock(),
          SizedBox(
            height: 5,
          ),
          _button()
        ],
      ),
    );
  }

  Widget _button() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_submit(), _cancel()]);

  Widget inputId() => TextFormField(
        decoration: inputStyle('id'),
        initialValue: product.id.toString(),
        keyboardType: TextInputType.number,
        validator: (String? value) {
          if (value == null || value.isEmpty || !isInt(value)) {
            return 'การุณากรอกข้อมูลให้ถูกต้อง';
          }
          return null;
        },
        onSaved: (newValue) => product.id = int.parse(newValue!),
      );

  Widget _inputPrice() => TextFormField(
        decoration: inputStyle('Price'),
        initialValue: product.price.toString(),
        keyboardType: TextInputType.number,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'การุณากรอกข้อมูล';
          }
          return null;
        },
        onSaved: (newValue) => product.price = int.parse(newValue!),
      );

  Widget _inputStock() => TextFormField(
        decoration: inputStyle('Stock'),
        initialValue: product.stock.toString(),
        keyboardType: TextInputType.number,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'การุณากรอกข้อมูล';
          }
          return null;
        },
        onSaved: (newValue) => product.stock = int.parse(newValue!),
      );

  Widget _inputName() => TextFormField(
        decoration: inputStyle('Name'),
        initialValue: product.name,
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'การุณากรอกข้อมูล';
          }
          return null;
        },
        onSaved: (newValue) => product.name = newValue!,
      );
  Widget _cancel() => OutlinedButton(
      onPressed: () => Navigator.pop(context), child: Text('Cancel'));

  Widget _submit() =>
      ElevatedButton(onPressed: _buildSubmit, child: Text('Submit'));

  InputDecoration inputStyle(label) => InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black12,
            width: 2,
          ),
        ),
        labelText: label,
      );

  _buildSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState!.save();
    //print(product.toJson());
    var result = await NetworkService().addProduct(product, imageFile: _imageFile);
    //if (formKey.currentState!.validate()) {
      if (result == API.OK) {
      Navigator.pop(context);
      } else {
      _buildShow(result);
      }
      
  }

  void _buildShow(String? result) {
      showDialog<String>(
context: context,
builder: (BuildContext context) => AlertDialog(
backgroundColor: Colors.yellowAccent,
title: Text('$result'),
content: null,
actions: <Widget>[
TextButton(
onPressed: () => Navigator.pop(context, 'Close'),
child: const Text('Close'),
),
],
),
);
}


  Widget _image() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPickerImage(),

          _buildPreviewImage(),
        ],
      ),
    );
  }

  Widget _buildPreviewImage() {
    return _imageFile.path.isNotEmpty
        ? Container(
            color: Colors.grey[100],
            margin: EdgeInsets.only(top: 4),
            alignment: Alignment.center,
            height: 200,
            child: Image.file(_imageFile),
          )
        : SizedBox();
  }

  OutlinedButton _buildPickerImage() => OutlinedButton.icon(
        onPressed: () {
          _modalPickerImage();
        },
        label: Text('image'),
        icon: Icon(Icons.image),
      );

  void _modalPickerImage() {
// ignore: prefer_function_declarations_over_variables
    final buildListTile =
        (IconData icon, String title, ImageSource imageSource) => ListTile(
              leading: Icon(icon),
              title: Text(title),
              onTap: () {
                Navigator.pop(context);
            _pickImage(imageSource);
              },
            );
    showModalBottomSheet(///ของ flutter
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildListTile(
              Icons.photo_camera,
              "Take a picture from camera",
              ImageSource.camera,
            ),
            buildListTile(
              Icons.photo_library,
              "Choose from photo library",
              ImageSource.gallery,
            ),
          ],
        ),
      ),
    );
  }


void _pickImage(ImageSource imageSource) {
    _picker
        .pickImage(
      source: imageSource,
      imageQuality: 70,
      maxHeight: 500,
      maxWidth: 500,
    )
        .then((file) {
      if (file != null) {
        setState(() {
          _imageFile = File(file.path);
        });
      }
    });
  }


}
