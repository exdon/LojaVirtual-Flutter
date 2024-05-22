import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  late String id;
  late String category;
  late String productId;
  late int quantity;
  late String size;

  ProductData? productData;

  // Construtor vazio para permitir instanciar CartProduct
  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    id = document.id;
    category = document.get("category");
    productId = document.get("productId");
    quantity = document.get("quantity");
    size = document.get("size");
  }

  // Convertendo para Map para salvar no Firebase
  Map<String, dynamic> toMap() {
    return {
      "category": category,
      "productId": productId,
      "quantity": quantity,
      "size": size,
      "product": productData?.toResumedMap()
    };
  }
}