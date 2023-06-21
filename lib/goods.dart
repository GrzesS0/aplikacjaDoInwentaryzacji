import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/alert.dart';
import 'package:provider/provider.dart';
import 'database.dart';
import 'element_of_database.dart';
import 'custom_floating_action_button.dart';

class Goods extends StatefulWidget {
  //ze stanem - dynamiczny obraz który możemy odświerzać.
  const Goods({super.key});

  @override
  State<Goods> createState() => _Goods();
}

class _Goods extends State<Goods> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<Database>(context,
        listen:
            true); //zmienna do zarządania stanem aplikacji (potrzebne by wyświetlały się aktualne dane)

    return WillPopScope(
      onWillPop: () async {
        if (state.path.isNotEmpty) {
          state.pathPrevious();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: Offset(-0.5, -0.5),
              ),
              Shadow(
                color: Colors.black,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
          title: Text(
            state.title == "Inwentaryzacja" ? "Towary" : state.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  offset: Offset(-0.5, -0.5),
                ),
                Shadow(
                  color: Colors.black,
                  blurRadius: 2,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ), //odwołanie do parametru title
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width, //szerokość ekranu
            height: MediaQuery.of(context).size.height, //wysokość ekranu
            child: ListView(
              //skrolowalna lista
              children: List.generate(
                state.database.length,
                (index) => ElementOfDatabase(
                  index: index,
                  function: () {},
                ),
              ), //generator elementów (wizualnych) listy),
            ),
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
            iconData: Icons.add,
            function: () {
              Alert.add(
                  context: context,
                  title: "Dodaj nowy Przedmiot"); // Budynek Pokój
            }),
      ),
    );
  }
}
