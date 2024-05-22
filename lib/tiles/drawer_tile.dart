import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {super.key,
      required this.icon,
      required this.text,
      required this.page,
      required this.pageController});

  final IconData icon;
  final String text;
  final int page;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    // Vamos utilizar o Material para dar um efeito quando os icones forem clicados
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          //Para fechar o Drawer
          Navigator.of(context).pop();
          //passando qual página ele deve ir
          pageController.jumpToPage(page);
        },
        child: Container(
          height: 60,
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: pageController.page?.round() == page
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
              // Widget invísivel para dar espaçamento entre Widgets
              const SizedBox(width: 32),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  color: pageController.page?.round() == page
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
