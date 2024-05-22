import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildBodyBack() => Container(
          decoration: const BoxDecoration(
            // Degradê
            gradient: LinearGradient(
              colors: [
                // Cor de cima
                Color.fromARGB(255, 211, 118, 130),
                // Cor de baixo
                Color.fromARGB(255, 253, 181, 168),
              ],
              // Define onde o degradê começa/termina
              begin: Alignment.topLeft, // começa no canto superior esquerdo
              end: Alignment.bottomRight, // termina no canto inferior direito
            ),
          ),
        );

    // Stack retorna o conteúdo acima do outro
    return Stack(
      children: [
        buildBodyBack(),
        // Ficará em cima do buildBodyBack
        CustomScrollView(
          // ScrollView customizado
          slivers: [
            const SliverAppBar(
                floating: true,
                //snap - quando arrasta pra baixo a SliverAppBar some
                // quando arrasta pra cima, ela reaparece
                snap: true,
                backgroundColor: Colors.transparent,
                // define a elavção da barra. NO caso ela ficará sem elevação
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Novidades"),
                  centerTitle: true,
                )),
            FutureBuilder<QuerySnapshot>(
              // Pegando os dados do Firebase
              future: FirebaseFirestore.instance
                  .collection("home") // nome da collection
                  .orderBy("pos") // ordenação dos dados
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  // Caso ainda não tenha carregado os dados
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                } else {
                  // Dados retornados do Firebase
                  return SliverToBoxAdapter(
                    child: GridView.custom(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverQuiltedGridDelegate(
                          // qtd de blocos que irá ocupar na horizontal
                          crossAxisCount: 2,
                          mainAxisSpacing: 1, //espaçamento vertical
                          crossAxisSpacing: 1, //espaçamento horizontal
                          pattern: snapshot.data!.docs.map((doc) {
                            // pegando as dimensões definidas no Firebase
                            return QuiltedGridTile(doc["y"], doc["x"]);
                          }).toList()),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (context, index) => FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: snapshot.data!.docs[index]['image'],
                          fit: BoxFit.cover,
                        ),
                        childCount: snapshot.data!.docs.length
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
