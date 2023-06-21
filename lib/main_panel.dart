import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/database.dart';
import 'package:projekt_inzynieria_oprogramowania/goods.dart';
import 'package:projekt_inzynieria_oprogramowania/inventory.dart';
import 'package:projekt_inzynieria_oprogramowania/reports.dart';
import 'package:projekt_inzynieria_oprogramowania/user_data.dart';
import 'package:provider/provider.dart';

import 'alert.dart';

class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({super.key, this.text = ""});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (text == "Towary"&&Provider.of<Database>(context,listen: false).user?.accessLevel == AccessLevel.readOnly) {
            Alert.communique(context, "Brak uprawnień do edycji bazy danych.");
          }else{
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                if (text == "Raporty") {
                  return const Reports();
                }
                if (text == "Towary") {
                  Provider.of<Database>(context, listen: false).isAccessToEdit =
                      true;
                  return const Goods();
                }
                Provider.of<Database>(context, listen: false).isAccessToEdit =
                    false;
                return const Inventory();
              },
            ),
          );}
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.75 / 3,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.lightGreen.shade500,
                  Colors.lightGreen.shade600,
                  Colors.lightGreen.shade700,
                  Colors.lightGreen.shade800,
                ],
                stops: const [0.1, 0.3, 0.6, 0.8],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: const Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 0.1,
                ),
                const BoxShadow(
                  color: Colors.black54,
                  offset: Offset(10, 10),
                  blurRadius: 15,
                  spreadRadius: 4,
                ),
              ],
              color: Colors.grey,
              border: Border.all(color: Colors.grey.shade500, width: 2),
              borderRadius: BorderRadius.circular(13)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
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
                ),
                Icon(
                  text == "Inwentaryzacja"
                      ? Icons.book_outlined
                      : text == "Raporty"
                          ? Icons.event_note_sharp
                          : Icons.warehouse,
                  color: Colors.white,
                  size: 80,
                  shadows: const [
                    Shadow(
                      color: Colors.lightGreen,
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
              ],
            ),
          ),
        ),
      );
}

class MainPanel extends StatelessWidget {
  const MainPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return Alert.logOut(context);
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.elliptical(200, 20))),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
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
          title: const Center(
            child: Text(
              "Panel Główny",
              textAlign: TextAlign.center,
            ), //odwołanie do parametru title
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              CustomButton(
                text: "Inwentaryzacja",
              ),
              CustomButton(
                text: "Raporty",
              ),
              CustomButton(text: "Towary"),
            ],
          ),
        ),
      ),
    );
  }
}
