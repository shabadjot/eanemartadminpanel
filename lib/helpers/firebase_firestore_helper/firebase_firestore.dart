import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eanemart_admin_panel/constants/constants.dart';
import 'package:eanemart_admin_panel/helpers/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:eanemart_admin_panel/models/category_model/category_model.dart';
import 'package:eanemart_admin_panel/models/orders_model/order_model.dart';
import 'package:eanemart_admin_panel/models/product_model/product_model.dart';
import 'package:eanemart_admin_panel/models/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<List<UserModel>> getUserList() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection("users").get();
    return querySnapshot.docs.map((e) => UserModel.fromJson(e.data())).toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore.collection("categories").get();

      List<CategoryModel> categoriesList = querySnapshot.docs
          .map((e) => CategoryModel.fromJson(e.data()))
          .toList();

      return categoriesList;
    } catch (e) {
      showMessage(e.toString());
      return [];
    }
  }

  Future<String> deleteSingleUser(String id) async {
    try {
      await _firebaseFirestore.collection("users").doc(id).delete();
      return "User Deleted Successfully";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateSingleUser(UserModel userModel) async {
    try {
      await _firebaseFirestore
          .collection("users")
          .doc(userModel.id)
          .update(userModel.toJson());
    } catch (e) {}
  }

  Future<String> deleteSingleCategories(String id) async {
    try {
      await _firebaseFirestore.collection("categories").doc(id).delete();
      return "categories Deleted Successfully";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateSingleCategories(CategoryModel categoryModel) async {
    try {
      await _firebaseFirestore
          .collection("categories")
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {}
  }

  Future<CategoryModel> addSingleCategories(File image, String name) async {
    CollectionReference reference = _firebaseFirestore.collection("categories");
    String imageUrl = await FirebaseStorageHelper.instance
        .uploadUserImage(reference.id, image);

    CategoryModel addCategory =
        CategoryModel(image: imageUrl, id: reference.id, name: name);
    await reference.add(addCategory.toJson());
    return addCategory;
  }

  // products

  Future<List<ProductModel>> getProducts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collectionGroup("products").get();
    List<ProductModel> productList =
        querySnapshot.docs.map((e) => ProductModel.fromJson(e.data())).toList();
    return productList;
  }

  Future<String> deleteProduct(String categoryId, String productId) async {
    try {
      await _firebaseFirestore
          .collection("categories")
          .doc(categoryId)
          .collection("products")
          .doc(productId)
          .delete();
      return "Product Deleted Successfully";
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateSingleProduct(ProductModel productModel) async {
    try {
      await _firebaseFirestore
          .collection("categories")
          .doc(productModel.categoryId)
          .collection("products")
          .doc(productModel.id)
          .update(productModel.toJson());
    } catch (e) {}
  }

  Future<ProductModel> addSingleProduct(
    File image,
    String name,
    String categoryId,
    String price,
    String description,
  ) async {
    CollectionReference reference = _firebaseFirestore
        .collection("categories")
        .doc(categoryId)
        .collection("products");
    String imageUrl = await FirebaseStorageHelper.instance
        .uploadUserImage(reference.id, image);

    ProductModel addProduct = ProductModel(
        image: imageUrl,
        id: reference.id,
        name: name,
        categoryId: categoryId,
        description: description,
        isFavourite: false,
        price: double.parse(price),
        qty: 1);
    await reference.add(addProduct.toJson());
    return addProduct;
  }

  Future<List<OrderModel>> getCompletedOrder() async {
    QuerySnapshot<Map<String, dynamic>> completedOrder =
        await _firebaseFirestore
            .collection("orders")
            .where("status", isEqualTo: "Completed")
            .get();
    List<OrderModel> completedOrderList =
        completedOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return completedOrderList;
  }

  Future<List<OrderModel>> getCancelOrder() async {
    QuerySnapshot<Map<String, dynamic>> cancelOrder = await _firebaseFirestore
        .collection("orders")
        .where("status", isEqualTo: "Cancel")
        .get();
    List<OrderModel> cancelOrderList =
        cancelOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return cancelOrderList;
  }

  Future<List<OrderModel>> getPendingOrder() async {
    QuerySnapshot<Map<String, dynamic>> pendingOrder = await _firebaseFirestore
        .collection("orders")
        .where("status", isEqualTo: "Pending")
        .get();
    List<OrderModel> pendingOrderList =
        pendingOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return pendingOrderList;
  }

  Future<void> updateOrder(OrderModel orderModel, String status) async {
    await _firebaseFirestore
        .collection("user orders")
        .doc(orderModel.userId)
        .collection("orders")
        .doc(orderModel.orderId)
        .update({
      "status": status,
    });
    await _firebaseFirestore
        .collection("orders")
        .doc(orderModel.orderId)
        .update({
      "status": status,
    });
  }

  Future<List<OrderModel>> getDeliveryOrders() async {
    QuerySnapshot<Map<String, dynamic>> deliveryOrder = await _firebaseFirestore
        .collection("orders")
        .where("status", isEqualTo: "Delivery")
        .get();
    List<OrderModel> deliveryOrderList =
        deliveryOrder.docs.map((e) => OrderModel.fromJson(e.data())).toList();
    return deliveryOrderList;
  }
}
