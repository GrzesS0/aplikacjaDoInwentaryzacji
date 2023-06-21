import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/alert.dart';
import 'package:projekt_inzynieria_oprogramowania/database.dart';
import 'package:projekt_inzynieria_oprogramowania/object_data.dart';
import 'package:provider/provider.dart';

class ElementOfDatabase extends StatelessWidget {
  const ElementOfDatabase(
      {required this.index, required this.function, super.key});

  final int index;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<Database>(context,
        listen:
            false); //zmienna do zarządania stanem aplikacji (potrzebne by wyświetlały się aktualne dane)
    return GestureDetector(
      onTap: () {
        if (state.database[index].stanInwentaryzaji ==
            StanInwentaryzaji.zinwentaryzowany) {
          function();
        } else {
          if (state.path.length != 2) {
            //to znaczy że nie jest w pomieszczeniu (i w budynku)
            state.pathAdd(state.database[index]);
          }
        }
      },
      onLongPress: () {
        if (state.isAccessToEdit) {
          Alert.edit(context: context, title: "Edytuj lub Usuń", index: index);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
          //gradient: LinearGradient(colors: [Colors.lightGreen,Colors.lightGreenAccent],stops: [0.6,1]),//alternatywnie można poeksepymentować z gradentem by lepie to wyglądało
          boxShadow: const [
            BoxShadow(
                color: Colors.black45, offset: Offset(3, 3), blurRadius: 3),
            BoxShadow(
                color: Colors.white10, offset: Offset(-2, -2), blurRadius: 2)
          ],
          //cień na dole, światło na górze, można poeksperymentować bybyło lepiej
          color: state.database[index].stanInwentaryzaji ==
                      StanInwentaryzaji.zinwentaryzowany ||
                  state.isAccessToEdit
              ? Colors.lightGreen
              : state.database[index].stanInwentaryzaji ==
                      StanInwentaryzaji.wTrakcieInwentaryzacji
                  ? Colors.amberAccent
                  : Colors.red,
        ),
        child: DefaultTextStyle(
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
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    state.database[index].nazwa,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              state.database[index].kodKreskowy == null
                  ? const SizedBox()
                  : Text(
                      "Kod kreskowy: ${state.database[index].kodKreskowy}",
                      style: const TextStyle(fontSize: 15),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
