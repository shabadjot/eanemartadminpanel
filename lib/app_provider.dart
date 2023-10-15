import 'dart:io';

import 'package:eanemart_admin_panel/constants/constants.dart';
import 'package:eanemart_admin_panel/helpers/firebase_firestore_helper/firebase_firestore.dart';
import 'package:eanemart_admin_panel/models/category_model/category_model.dart';
import 'package:eanemart_admin_panel/models/orders_model/order_model.dart';
import 'package:eanemart_admin_panel/models/product_model/product_model.dart';
import 'package:eanemart_admin_panel/models/user_model/user_model.dart';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  List<UserModel> _userList = [];
  List<CategoryModel> _categoriesList = [];
  List<ProductModel> _productList = [];
  List<OrderModel> _completedOrderList = [];
  List<OrderModel> _cancelOrderList = [];
  List<OrderModel> _pendingOrderList = [];
  List<OrderModel> _deliveryOrdersList = [];

  double _totalEarning = 0.0;
  Future<void> getUserListFun() async {
    _userList = await FirebaseFirestoreHelper.instance.getUserList();
  }

  Future<void> getCompletedOrder() async {
    _completedOrderList =
        await FirebaseFirestoreHelper.instance.getCompletedOrder();
    for (var element in _completedOrderList) {
      _totalEarning += element.totalPrice;
    }
    notifyListeners();
  }

  Future<void> getCancelOrder() async {
    _cancelOrderList = await FirebaseFirestoreHelper.instance.getCancelOrder();
    notifyListeners();
  }

  Future<void> getDeliveryOrder() async {
    _deliveryOrdersList =
        await FirebaseFirestoreHelper.instance.getDeliveryOrders();
    notifyListeners();
  }

  Future<void> getPendingOrder() async {
    _pendingOrderList =
        await FirebaseFirestoreHelper.instance.getPendingOrder();
    notifyListeners();
  }

  Future<void> getCategoryListFun() async {
    _categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
  }

  Future<void> deleteUserInfoFirebase(UserModel userModel) async {
    notifyListeners();
    String value =
        await FirebaseFirestoreHelper.instance.deleteSingleUser(userModel.id);
    if (value == "User Deleted Successfully") {
      _userList.remove(userModel);
      showMessage("User Deleted Successfully");
    }
    notifyListeners();
  }

  List<UserModel> get getUserList => _userList;
  double get getTotalEarning => _totalEarning;
  List<CategoryModel> get getCategories => _categoriesList;
  List<ProductModel> get getProducts => _productList;
  List<OrderModel> get getCompletedOrderList => _completedOrderList;
  List<OrderModel> get getCancelOrderList => _cancelOrderList;
  List<OrderModel> get getPendingOrderList => _pendingOrderList;
  List<OrderModel> get getDeliveryOrderLists => _deliveryOrdersList;

  Future<void> callBackFunction() async {
    await getUserListFun();
    await getCategoryListFun();
    await getProduct();
    await getCompletedOrder();
    await getCancelOrder();
    await getPendingOrder();
    await getDeliveryOrder();
  }

  void updateUserList(int index, UserModel userModel) async {
    await FirebaseFirestoreHelper.instance.updateSingleUser(userModel);
    // int index = _userList.indexOf(userModel);
    _userList[index] = userModel;
    notifyListeners();
  }

  // category
  Future<void> deleteCategoriesInfoFirebase(CategoryModel categoryModel) async {
    notifyListeners();
    String value = await FirebaseFirestoreHelper.instance
        .deleteSingleCategories(categoryModel.id);
    if (value == "categories Deleted Successfully") {
      _categoriesList.remove(categoryModel);
      showMessage("categories Deleted Successfully");
    }
    notifyListeners();
  }

  void updateCategoriesList(int index, CategoryModel categoryModel) async {
    await FirebaseFirestoreHelper.instance
        .updateSingleCategories(categoryModel);
    // int index = _userList.indexOf(userModel);
    _categoriesList[index] = categoryModel;
    notifyListeners();
  }

  void addCategory(File image, String name) async {
    CategoryModel categoryModel =
        await FirebaseFirestoreHelper.instance.addSingleCategories(image, name);
    _categoriesList.add(categoryModel);
    notifyListeners();
  }

  Future<void> getProduct() async {
    _productList = await FirebaseFirestoreHelper.instance.getProducts();
    notifyListeners();
  }

  Future<void> deleteProductFromFirebase(ProductModel productModel) async {
    String value = await FirebaseFirestoreHelper.instance
        .deleteProduct(productModel.categoryId, productModel.id);
    if (value == "Product Deleted Successfully") {
      _productList.remove(productModel);
      showMessage("Product Deleted Successfully");
    }
  }

  void updateProductList(int index, ProductModel productModel) async {
    await FirebaseFirestoreHelper.instance.updateSingleProduct(productModel);
    // int index = _userList.indexOf(userModel);
    _productList[index] = productModel;
    notifyListeners();
  }

  void addProduct(
    File image,
    String name,
    String categoryId,
    String price,
    String description,
  ) async {
    ProductModel productModel = await FirebaseFirestoreHelper.instance
        .addSingleProduct(image, name, categoryId, price, description);
    _productList.add(productModel);
    notifyListeners();
  }

  void updatePendingOrder(OrderModel order) {
    _deliveryOrdersList.add(order);
    _pendingOrderList.remove(order);
    notifyListeners();
    showMessage("Sended to delivery");
  }

  void updateCancelPendingOrder(OrderModel order) {
    _cancelOrderList.add(order);
    _pendingOrderList.remove(order);
    notifyListeners();
    showMessage("Successfully Cancelled Pending order");
    notifyListeners();
  }

  void updateCancelDeliveryOrder(OrderModel order) {
    _cancelOrderList.add(order);
    _deliveryOrdersList.remove(order);
    notifyListeners();
    showMessage("Successfully Cancelled");
    notifyListeners();
  }
}
