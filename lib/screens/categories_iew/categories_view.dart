import 'package:eanemart_admin_panel/app_provider.dart';
import 'package:eanemart_admin_panel/constants/routes.dart';
import 'package:eanemart_admin_panel/models/category_model/category_model.dart';
import 'package:eanemart_admin_panel/screens/categories_iew/add_categories/add_catgories.dart';
import 'package:eanemart_admin_panel/screens/categories_iew/widgets/single_category_iytem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Categoriesview extends StatelessWidget {
  const Categoriesview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories View"),
        actions: [
          IconButton(
              onPressed: () {
                Routes.instance.push(widget: AddCategory(), context: context);
              },
              icon: Icon(Icons.add_circle))
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Categories",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: value.getCategories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      CategoryModel categoryModel = value.getCategories[index];
                      return SingleCategoryItem(
                        singleCategory: categoryModel,
                        index: index,
                      );
                      //   index: index,
                      //   userModel: userModel,
                      // );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
