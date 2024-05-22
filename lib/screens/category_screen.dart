import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';

import '../tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.snapshot});

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // qtd de tabs
      child: Scaffold(
          appBar: AppBar(
            title: Text(snapshot.get("title")),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: Colors.white, // cor que indica tab atual
              tabs: [
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                ),
              ],
            ),
          ),
          body: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("products")
                .doc(snapshot.id)
                .collection("items")
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return TabBarView(
                  // o que queremos mostrar em cada Tab
                  physics: const NeverScrollableScrollPhysics(),
                  //bloqueia o arrastar para mudar de tab
                  children: [
                    // GridView.builder - carrega os dados conforme vc for rolando a tela
                    GridView.builder(
                      padding: const EdgeInsets.all(4),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // qtd de itens na horizontal
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 0.64, // larg / alt = aspectRatio
                      ),
                      // qtd de itens do Grid
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        ProductData product =  ProductData.fromDocument(
                            snapshot.data!.docs[index]);
                        product.category = this.snapshot.id;

                        return ProductTile(
                          type: "grid",
                          product: product,
                        );
                      },
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.all(4),
                      // qtd de itens da Lista
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {

                        ProductData product =  ProductData.fromDocument(
                            snapshot.data!.docs[index]);
                        product.category = this.snapshot.id;

                        return ProductTile(
                          type: "list",
                          product: product,
                        );
                      },
                    )
                  ],
                );
              }
            },
          )),
    );
  }
}
