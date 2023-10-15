import 'package:eanemart_admin_panel/app_provider.dart';
import 'package:eanemart_admin_panel/models/user_model/user_model.dart';
import 'package:eanemart_admin_panel/screens/user_view/widgets/single_user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User View"),
      ),
      body: Consumer<AppProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.getUserList.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              UserModel userModel = value.getUserList[index];
              return SingleUserCard(
                index: index,
                userModel: userModel,
              );
            },
          );
        },
      ),
    );
  }
}
