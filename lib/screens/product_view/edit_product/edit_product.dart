import 'dart:io';
import 'package:eanemart_admin_panel/constants/constants.dart';
import 'package:eanemart_admin_panel/helpers/firebase_storage_helper/firebase_storage_helper.dart';
// import 'package:eanemart_admin_panel/models/category_model/category_model.dart';
import 'package:eanemart_admin_panel/models/product_model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';

class EditProducts extends StatefulWidget {
  final ProductModel productModel;
  final int index;

  const EditProducts({
    super.key,
    required this.productModel,
    required this.index,
  });

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
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

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Edit categories",
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
              ? widget.productModel.image.isNotEmpty
                  ? CupertinoButton(
                      onPressed: () {
                        takePicture();
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            NetworkImage(widget.productModel.image),
                      ),
                    )
                  : CupertinoButton(
                      onPressed: () {
                        takePicture();
                      },
                      child: const CircleAvatar(
                          radius: 55, child: Icon(Icons.camera_alt)),
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
            decoration: InputDecoration(hintText: widget.productModel.name),
          ),
          TextFormField(
            controller: description,
            maxLines: 7,
            decoration:
                InputDecoration(hintText: widget.productModel.description),
          ),
          TextFormField(
            controller: price,
            decoration:
                InputDecoration(hintText: "\$${widget.productModel.price}"),
          ),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () async {
              if (image != null &&
                  name.text.isEmpty &&
                  description.text.isEmpty &&
                  price.text.isEmpty) {
                Navigator.of(context).pop();
              } else if (image != null) {
                String imageUrl = await FirebaseStorageHelper.instance
                    .uploadUserImage(widget.productModel.id, image!);
                ProductModel productModel = widget.productModel.copyWith(
                  description:
                      description.text.isEmpty ? null : description.text,
                  image: imageUrl,
                  name: name.text.isEmpty ? null : name.text,
                  price: price.text.isEmpty ? null : price.text,
                );
                appProvider.updateProductList(widget.index, productModel);
                // appProvider.updateCategoriesList(widget.index, categoryModel);

                showMessage("Product Updated successfully");
              } else {
                ProductModel productModel = widget.productModel.copyWith(
                  description:
                      description.text.isEmpty ? null : description.text,
                  name: name.text.isEmpty ? null : name.text,
                  price: price.text.isEmpty ? null : price.text,
                );
                appProvider.updateProductList(widget.index, productModel);

                showMessage("Product Updated successfully");
              }
            },
          )
        ],
      ),
    );
  }
}
