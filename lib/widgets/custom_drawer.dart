import 'package:flutter/material.dart';
import 'package:loja_virtual/consts/Page.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/user_model.dart';
import '../tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    Widget buildDrawerBack() => Container(
          decoration: const BoxDecoration(
            // Degradê
            gradient: LinearGradient(
              colors: [
                // Cor de cima
                Color.fromARGB(255, 203, 236, 241),
                // Cor de baixo
                Colors.white,
              ],
              // Define onde o degradê começa/termina
              begin: Alignment.topCenter, // começa no canto superior inteiro
              end: Alignment.bottomCenter, // termina no canto inferior inteiro
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: [
          buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32, top: 16),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
                height: 170,
                child: Stack(
                  children: [
                    //Positioned define onde o filho(child) ficará posicionado
                    const Positioned(
                      top: 8,
                      left: 0,
                      child: Text(
                        "Flutter's\nClothing",
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      // ScopedModelDescendant - quanto tiver mudança no UserModel
                      // o builder será chamado e construirá o que estiver nele com os novos dados
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                model.isLoogedIn()
                                    ? "Olá, ${model.userData["name"]}"
                                    : "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoogedIn()
                                      ? "Entre ou Cadastre-se >"
                                      : "Sair",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    // pega a primaryColos definida em Theme
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                onTap: () {
                                  if (!model.isLoogedIn()) {
                                    // Navegando para tela de Login(LoginScreen)
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  } else {
                                    // Fazendo logout
                                    model.signOut();
                                  }
                                },
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              DrawerTile(
                  pageController: pageController,
                  icon: Icons.home,
                  text: "Início",
                  page: PageConstant.HOME),
              DrawerTile(
                  pageController: pageController,
                  icon: Icons.list,
                  text: "Produtos",
                  page: PageConstant.PRODUCTS),
              DrawerTile(
                  pageController: pageController,
                  icon: Icons.location_on,
                  text: "Lojas",
                  page: PageConstant.STORES),
              DrawerTile(
                  pageController: pageController,
                  icon: Icons.playlist_add_check,
                  text: "Meus Pedidos",
                  page: PageConstant.MY_ORDERS),
            ],
          )
        ],
      ),
    );
  }
}
