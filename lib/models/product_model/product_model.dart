// ignore_for_file: override_on_non_overriding_member

import 'dart:convert';

// ignore: non_constant_identifier_names
ProductModel ProductModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

// ignore: non_constant_identifier_names
Future<String> ProductModelToJson(ProductModel data) async =>
    json.encode(data.toJson());

class ProductModel {
  ProductModel({
    required this.image,
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.isFavourite,
    this.qty,
  });

  String image;
  String id, categoryId;
  bool isFavourite;
  String name;
  double price;
  String description;

  int? qty;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        categoryId: json["categoryId"] ?? "",
        isFavourite: false,
        price: double.parse(json["price"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "description": description,
        "isFavourite": isFavourite,
        "price": price,
        "categoryId": categoryId,
        "qty": qty,
      };

  ProductModel copyWith({
    String? name,
    String? image,
    String? id,
    String? categoryId,
    String? price,
    String? description,
  }) =>
      ProductModel(
          id: id ?? this.id,
          name: name ?? this.name,
          categoryId: id ?? this.categoryId,
          description: id ?? this.description,
          isFavourite: false,
          price: price != null ? double.parse(price) : this.price,
          image: image ?? this.image,
          qty: 1);
}
