import 'dart:io';
import 'package:eanemart_admin_panel/constants/constants.dart';
import 'package:eanemart_admin_panel/models/category_model/category_model.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({
    super.key,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? image;
  void takePicture() async {
    XFile? value = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  CategoryModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Add Product",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        children: [
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child:
                      CircleAvatar(radius: 55, child: Icon(Icons.camera_alt)),
                )
              : CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: CircleAvatar(
                    backgroundImage: FileImage(image!),
                    radius: 55,
                  ),
                ),
          const SizedBox(
            height: 12.0,
          ),
          TextFormField(
            controller: name,
            decoration: InputDecoration(hintText: "Product Name"),
          ),
          SizedBox(
            height: 24.0,
          ),
          TextFormField(
            controller: description,
            maxLines: 7,
            decoration: InputDecoration(hintText: "Product Description"),
          ),
          SizedBox(
            height: 24.0,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: DropdownButtonFormField(
              value: _selectedCategory,
              hint: Text(
                'Please select the category',
              ),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: appProvider.getCategories.map((CategoryModel val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(
                    val.name,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          TextFormField(
            controller: price,
            decoration: InputDecoration(hintText: "\$ Product price"),
          ),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              if (image == null ||
                  name.text.isEmpty ||
                  description.text.isEmpty ||
                  price.text.isEmpty) {
                showMessage("All Fields are mandatory");
              } else {
                appProvider.addProduct(image!, name.text, _selectedCategory!.id,
                    price.text, description.text);
                // appProvider.updateCategoriesList(widget.index, categoryModel);

                // showMessage("Product Updated successfully");
              }
            },
          )
        ],
      ),
    );
  }
}
