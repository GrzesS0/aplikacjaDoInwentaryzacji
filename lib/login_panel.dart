import 'dart:math';
import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/alert.dart';
import 'package:projekt_inzynieria_oprogramowania/database.dart';
import 'package:projekt_inzynieria_oprogramowania/main_panel.dart';
import 'package:projekt_inzynieria_oprogramowania/object_data.dart';
import 'package:projekt_inzynieria_oprogramowania/text_field.dart';
import 'package:projekt_inzynieria_oprogramowania/user_data.dart';
import 'package:provider/provider.dart';

class LoginPanel extends StatefulWidget {
  const LoginPanel({super.key});

  @override
  State<LoginPanel> createState() => _LoginPanel();
}

class _LoginPanel extends State<LoginPanel> {
  String _login = "";
  String _password = "";
  List<UserData> _users = [];
  bool isCommuniqueVisible = false;

  @override
  void initState() {
    _users = [
      UserData(
          login: "admin",
          password: "admin!",
          name: "Jan",
          surname: "Kowalski",
          accessLevel: AccessLevel.edit),
      UserData(
          login: "magazynier",
          password: "magazynier!",
          name: "Adam",
          surname: "Nowak",
          accessLevel: AccessLevel.readOnly)
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<Database>(context, listen: false);
      if (state.database.isEmpty && state.path.isEmpty) {
        state.database = List.generate(
          2,
          (i) => DanePrzedmiotu(
            nazwa: "Budynek $i",
            zawartoscPodprzedmioty: List.generate(
              2,
              (j) => DanePrzedmiotu(
                nazwa: "Pokój $j",
                zawartoscPodprzedmioty: List.generate(
                  20,
                  (k) => DanePrzedmiotu(
                    nazwa: "Przedmiot $k",
                    kodKreskowy: (1000000 + i * 10000 + j * 100 + k).toString(),
                    zawartoscPodprzedmioty: [],
                  ),
                ),
              ),
            ),
          ),
        );

        //testy raportów
        Random rng = Random();
        state.database.forEach((element) {
          element.zawartoscPodprzedmioty.forEach((element) {
            element.zawartoscPodprzedmioty.forEach((element) {
              if (rng.nextBool())
                element.stanInwentaryzaji = StanInwentaryzaji.zinwentaryzowany;
            });
            element.nietutejszePrzedmioty.add( DanePrzedmiotu(
              nazwa: "Przedmiot obcy",
              kodKreskowy: "0000000",
              zawartoscPodprzedmioty: [],
              pochodzenie: "z daleka - testowa baza danych"
            ),);
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(200, 20),
          ),
        ),
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
            "Panel logowania",
            textAlign: TextAlign.center,
          ), //odwołanie do parametru title
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
            image: DecorationImage(
                scale: 2.6,
                image: AssetImage("assets/logo.png"),
                //fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.topCenter)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  title: "Podaj login",
                  onChanged: (value) {
                    _login = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CustomTextField(
                  title: "Podaj hasło",
                  onChanged: (value) {
                    _password = value;
                  },
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  UserData? user;
                  if (_users.any((element) {
                    user = element;
                    return element.isPasswordCorrect(_login, _password);
                  })) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Provider.of<Database>(context, listen: false).user = user;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPanel(),
                      ),
                    );
                  } else {
                    if (!isCommuniqueVisible) {
                      isCommuniqueVisible = true;
                      Alert.communique(
                          context, "nieprawidłowy login lub hasło");
                      Future.delayed(const Duration(seconds: 3), () {
                        isCommuniqueVisible = false;
                      });
                    }
                  }
                },
                child: const Text(
                  "Zaloguj",
                  style: TextStyle(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
