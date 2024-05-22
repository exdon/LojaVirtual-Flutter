import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

import '../datas/cart_product.dart';

class CartModel extends Model {
  UserModel user;
  List<CartProduct> products = [];

  String? couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user) {
    if (user.isLoogedIn()) {
      // carrega os itens do carrinho
      _loadCartItems();
    }
  }

  // Para acessar o CartModel sem ser pelo ScopedModelDescendant
  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  // Função para notificar o flutter e atualizar o preço do carrinho
  void updatePrices() {
    notifyListeners();
  }

  //Função que adiciona um novo produto no carrinho
  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        //irá criar essa subcoleção 'cart' para armazenar os produtos do carrinho
        .collection("cart")
        .add(cartProduct.toMap())
        .then((doc) {
      //salvando o id do produto no carrinho
      cartProduct.id = doc.id;
    });

    notifyListeners();
  }

  //Função que remove um produto no carrinho
  void removeCartItem(CartProduct cartProduct) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.id)
        .delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  //Função que decrementa a quantidade de um produto no carrinho
  void decProduct(CartProduct cartProduct) {
    cartProduct.quantity--;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.id)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  //Função que incrementa a quantidade de um produto no carrinho
  void incProduct(CartProduct cartProduct) {
    cartProduct.quantity++;

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .doc(cartProduct.id)
        .update(cartProduct.toMap());

    notifyListeners();
  }

  // Função que adiciona o cupom de desconto no preço dos produtos que estão no carrinho
  void setCoupon(String couponCode, int discountPercentage) {
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  // Função que retorna o preço subtotal de todos os produtos que estão no carrinho
  double getProductsPrice() {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) {
        price += c.quantity * c.productData!.price;
      }
    }
    return price;
  }

  // Função que retorna o desconto recebido no carrinho
  double getDiscount() {
    return getProductsPrice() * discountPercentage / 100;
  }

  // Função que retorna o preço do frete de todos os produtos que estão no carrinho
  double getShipPrice() {
    //TODO - Implementar cálculo de frete
    return 9.99;
  }

  // Função que finaliza o pedido do carrinho
  Future<String> finishOrder() async {
    if (products.isEmpty) return "";

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    // Criando pedido no Firebase
    DocumentReference refOrder = await FirebaseFirestore.instance
        .collection("orders")
        .add(
            {
              "clientId": user.firebaseUser?.uid,
              "products": products.map((cartProduct) => cartProduct.toMap()).toList(),
              "shipPrice": shipPrice,
              "productsPrice": productsPrice,
              "discount": discount,
              "totalPrice": productsPrice - discount + shipPrice,
              "status": 1
            }
        );

    //Vinculando o id do pedido ao usuário
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser?.uid)
        .collection("orders")
        .doc(refOrder.id) //id do pedido
        .set(
            {
              "orderId": refOrder.id
            }
        );

    //Removendo os produtos do carrinho
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser?.uid)
        .collection("cart")
        .get();

    for(DocumentSnapshot doc in query.docs) {
      //deletando todos os produtos do carrinho
      doc.reference.delete();
    }

    products.clear();
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    // Retornando o id do pedido
    return refOrder.id;
  }

  // Função que retorna todos os produtos que estão no carrinho
  void _loadCartItems() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.firebaseUser!.uid)
        .collection("cart")
        .get();

    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}
