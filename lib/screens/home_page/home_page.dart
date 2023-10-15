import 'package:eanemart_admin_panel/app_provider.dart';
import 'package:eanemart_admin_panel/constants/routes.dart';
import 'package:eanemart_admin_panel/screens/categories_iew/categories_view.dart';
import 'package:eanemart_admin_panel/screens/home_page/wdgets/single_dash_item.dart';
import 'package:eanemart_admin_panel/screens/order_list/order_list.dart';
import 'package:eanemart_admin_panel/screens/product_view/product_view.dart';
import 'package:eanemart_admin_panel/screens/user_view/user_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  void getData() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.callBackFunction();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Eane Mart Dashboard"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    const Text(
                      "Eane Mart",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      "eanemart@gmail.com",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 13.0,
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text("Send notifications to wholle users")),
                    GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(top: 12.0),
                      crossAxisCount: 2,
                      children: [
                        SingleDashItem(
                          subtitle: "Users",
                          title: appProvider.getUserList.length.toString(),
                          onPressed: () {
                            Routes.instance
                                .push(widget: UserView(), context: context);
                          },
                        ),
                        SingleDashItem(
                          subtitle: "Categories",
                          title: appProvider.getCategories.length.toString(),
                          onPressed: () {
                            Routes.instance.push(
                                widget: Categoriesview(), context: context);
                          },
                        ),
                        SingleDashItem(
                          subtitle: "Products",
                          title: appProvider.getProducts.length.toString(),
                          onPressed: () {
                            Routes.instance
                                .push(widget: ProductView(), context: context);
                          },
                        ),
                        SingleDashItem(
                          subtitle: "Earning",
                          title: "\$${appProvider.getTotalEarning}",
                          onPressed: () {},
                        ),
                        SingleDashItem(
                          subtitle: "pending order",
                          title:
                              appProvider.getPendingOrderList.length.toString(),
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Pending",
                                ),
                                context: context);
                          },
                        ),
                        SingleDashItem(
                          subtitle: "completed order",
                          title: appProvider.getCompletedOrderList.length
                              .toString(),
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Completed Order",
                                ),
                                context: context);
                          },
                        ),
                        SingleDashItem(
                          subtitle: "cancel",
                          title:
                              appProvider.getCancelOrderList.length.toString(),
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Cancel Order",
                                ),
                                context: context);
                          },
                        ),
                        SingleDashItem(
                          subtitle: "Delivered Order",
                          title: appProvider.getDeliveryOrderLists.length
                              .toString(),
                          onPressed: () {
                            Routes.instance.push(
                                widget: OrderList(
                                  title: "Delivered Order",
                                ),
                                context: context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
