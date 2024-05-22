import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.snapshot});

  // Dados de documentos(categorias) do Firebase
  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // leading é o item que fica na esquerda
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.get("icon")),
      ),
      title: Text(snapshot.get("title")),
      // trailing é o item que fica na direita
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        // Navegando para tela CategoryScreen para carregar os itens dos produtos
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => CategoryScreen(snapshot: snapshot)),
        );
      },
    );
  }
}
