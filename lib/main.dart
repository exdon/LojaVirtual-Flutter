import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/cart_model.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAUEl_HkKx0ZLFJpCPtBmnr0chD_a_GyDU',
      appId: 'id',
      messagingSenderId: 'sendid',
      projectId: 'lojavirtualflutter-9a8b1',
      storageBucket: 'lojavirtualflutter-9a8b1.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //ScopedModel - para utilizar o package scoped_model
    // e permitir que tenhamos acesso aos dados do usuário em toda a aplicação
    return ScopedModel<UserModel>(
      model: UserModel(),
      // qual é o modelo que guardará o estado
      // Todos os filhos terão acesso ao UserModel e serão notificados/modificados
      // assim que algo/estado mudar
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: "Flutter's Clothing",
              theme: ThemeData(
                primarySwatch: Colors.blue,
                //fromARGB(opacidade, red, green, blue)
                primaryColor: const Color.fromARGB(255, 4, 125, 141),
                useMaterial3: true,
              ),
              debugShowCheckedModeBanner: false,
              home: HomeScreen(),
            ),
          );
        },
      ),
    );
  }
}
