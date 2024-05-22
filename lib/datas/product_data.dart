import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  late String category;
  late String id;
  late String title;
  late String description;
  late double price;
  late List images;
  late List sizes;

  // Setando os dados do Firebase
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    title = snapshot.get("title");
    description = snapshot.get("description");
    price = snapshot.get("price");
    images = snapshot.get("images");
    sizes = snapshot.get("sizes");
  }

  // Para salvar um resumo do produto
  Map<String, dynamic> toResumedMap() {
    return {
      "title": title,
      "description": description,
      "price": price
    };
  }
}