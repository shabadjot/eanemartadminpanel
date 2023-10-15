import 'package:eanemart_admin_panel/app_provider.dart';
import 'package:eanemart_admin_panel/constants/routes.dart';
import 'package:eanemart_admin_panel/models/user_model/user_model.dart';
import 'package:eanemart_admin_panel/screens/user_view/edit_user/edit_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleUserCard extends StatefulWidget {
  final UserModel userModel;
  final int index;
  const SingleUserCard({
    super.key,
    required this.userModel,
    required this.index,
  });

  @override
  State<SingleUserCard> createState() => _SingleUserCardState();
}

class _SingleUserCardState extends State<SingleUserCard> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            widget.userModel.image != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(widget.userModel.image!),
                    // child: const Icon(Icons.person),
                  )
                : const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            const SizedBox(
              width: 12.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.userModel.name),
                Text(widget.userModel.email),
              ],
            ),
            const Spacer(),
            isLoading
                ? const CircularProgressIndicator()
                : GestureDetector(
                    // padding: EdgeInsets.zero,
                    onTap: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await appProvider
                          .deleteUserInfoFirebase(widget.userModel);
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
            SizedBox(
              width: 6.0,
            ),
            GestureDetector(
              //  padding: EdgeInsets.zero,
              onTap: () async {
                Routes.instance.push(
                    widget: EditProfile(
                        index: widget.index, userModel: widget.userModel),
                    context: context);
              },
              child: const Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
