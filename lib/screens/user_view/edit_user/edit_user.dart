import 'dart:io';
import 'package:eanemart_admin_panel/constants/constants.dart';
import 'package:eanemart_admin_panel/helpers/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../app_provider.dart';
import '../../../models/user_model/user_model.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;
  final int index;

  const EditProfile({
    super.key,
    required this.userModel,
    required this.index,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Your Profile",
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
            decoration: InputDecoration(hintText: widget.userModel.name),
          ),
          const SizedBox(
            height: 24.0,
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () async {
              if (image != null && name.text.isEmpty) {
                Navigator.of(context).pop();
              } else if (image != null) {
                String imageUrl = await FirebaseStorageHelper.instance
                    .uploadUserImage(widget.userModel.id, image!);
                UserModel userModel = widget.userModel.copyWith(
                  image: imageUrl,
                  name: name.text.isEmpty ? null : name.text,
                );
                appProvider.updateUserList(widget.index, userModel);

                showMessage("User Updated successfully");
              } else {
                UserModel userModel = widget.userModel.copyWith(
                  name: name.text.isEmpty ? null : name.text,
                );
                appProvider.updateUserList(widget.index, userModel);

                showMessage("User Updated successfully");
              }
              Navigator.of(context).pop();

              // UserModel userModel = appProvider.getUserInformation
              //     .copyWith(name: textEditingController.text);
              // appProvider.updateUserInfoFirebase(context, userModel, image);
              // showMessage("Your profile updated successfully");
            },
          )
        ],
      ),
    );
  }
}
