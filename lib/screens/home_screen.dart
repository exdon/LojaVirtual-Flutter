import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';

import '../tabs/home_tab.dart';
import '../tabs/orders_tab.dart';
import '../tabs/places_tab.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Controller para mudança de página do PageView
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // PageView permite que ao arrastar mudemos que página
    return PageView(
      // proibi de arrastar para mudar de página
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      //children são todas as páginas do PageView
      children: [
        Scaffold(
          body: const HomeTab(),
          drawer: CustomDrawer(pageController: _pageController),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Produtos"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: const ProductsTab(),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Lojas"),
            centerTitle: true,
          ),
          drawer: CustomDrawer(pageController: _pageController),
          body: const PlacesTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: const OrdersTab(),
          drawer: CustomDrawer(pageController: _pageController),
        )
      ],
    );
  }
}
