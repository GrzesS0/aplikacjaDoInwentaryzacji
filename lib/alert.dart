import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:projekt_inzynieria_oprogramowania/report_data.dart';
import 'package:projekt_inzynieria_oprogramowania/text_field.dart';
import 'package:projekt_inzynieria_oprogramowania/database.dart';
import 'package:projekt_inzynieria_oprogramowania/object_data.dart';
import 'package:projekt_inzynieria_oprogramowania/user_data.dart';
import 'package:provider/provider.dart';

class Alert {
  static Future<void> show({
    required BuildContext context,
    required String title,
    Widget? content,
    String confirmName = "Potwierdź",
    String cancelName = "Anuluj",
    required void Function() confirmFunction,
  }) async {
    await showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21.0),
                  side: const BorderSide(color: Colors.grey)),
              titleTextStyle: const TextStyle(
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
              titlePadding: const EdgeInsets.all(17.5),
              title: Center(
                child: Text(title),
              ),
              content: content,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      // Ustawienie koloru tła przycisku
                      foregroundColor: Colors.yellow[50],
                      // Ustawienie koloru tła przycisku na niebieski
                      textStyle: const TextStyle(fontSize: 16)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(cancelName),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen,
                        // Ustawienie koloru tła przycisku
                        foregroundColor: Colors.yellow[50],
                        // Ustawienie koloru tła przycisku na niebieski
                        textStyle: const TextStyle(fontSize: 16)),
                    onPressed: () {
                      confirmFunction();
                    },
                    child: Text(confirmName))
              ],
            );
          },
        );
      },
    );
  }

  static void communique(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.lightGreen,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        content: Text(
          title,
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
        ),
      ),
    );
  }

  static void edit(
      {required BuildContext context,
      required String title,
      required int index,
      Widget? content,
      Function? function}) {
    String? nazwa;
    String? kodKreskowy;
    show(
      confirmFunction: () {
        Provider.of<Database>(context, listen: false).edit(
          index: index,
          nazwa: nazwa,
          kodKreskowy: kodKreskowy,
        );
        Navigator.of(context).pop();
      },
      context: context,
      title:
          "Edytuj lub usuń ${Provider.of<Database>(context, listen: false).database[index].nazwa}",
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 200, //wysokość
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomTextField(
              title: "Podaj nazwę",
              initialValue: Provider.of<Database>(context, listen: false)
                  .database[index]
                  .nazwa,
              onChanged: (value) {
                nazwa = value;
                if (nazwa == "") nazwa = null;
              },
            ),
            CustomTextField(
              title: "Podaj kod kreskowy",
              keyboardType: TextInputType.number,
              initialValue: Provider.of<Database>(context, listen: false)
                  .database[index]
                  .kodKreskowy,
              onChanged: (value) {
                kodKreskowy = value;
                if (kodKreskowy == "") kodKreskowy = null;
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen,
                // Ustawienie koloru tła przycisku
                foregroundColor: Colors.yellow[50],
                // Ustawienie koloru czcionki
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                show(
                    context: context,
                    title:
                        "Czy na pweno chcesz usunąć ${Provider.of<Database>(context, listen: false).database[index].nazwa}?",
                    confirmFunction: () {
                      Provider.of<Database>(context, listen: false)
                          .delete(index: index);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    cancelName: "Nie",
                    confirmName: "Tak");
              },
              child: const Text("Usuń"),
            ),
          ],
        ),
      ),
    );
  }

  static void add(
      {required BuildContext context,
      required String title,
      Widget? content,
      Function? function}) {
    final int type = Provider.of<Database>(context, listen: false).path.length;
    String? nazwa;
    String? kodKreskowy;
    show(
      confirmFunction: () {
        Provider.of<Database>(context, listen: false).add(
            DanePrzedmiotu(
                nazwa: nazwa as String,
                kodKreskowy: kodKreskowy,
                zawartoscPodprzedmioty: []),
            context);
        Navigator.of(context).pop();
      },
      context: context,
      title:
          "Dodaj nowy ${type == 0 ? "budynek" : type == 1 ? "pokój" : "przedmiot"}",
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: type == 2 ? 150 : 60, //wysokość
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomTextField(
              title: "Podaj nazwę",
              onChanged: (value) {
                nazwa = value;
                if (nazwa == "") nazwa = null;
              },
            ),
            if (type == 2)
              CustomTextField(
                title: "Podaj kod Kreskowy",
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  kodKreskowy = value;
                  if (kodKreskowy == "") kodKreskowy = null;
                },
              ),
          ],
        ),
      ),
    );
  }

  static Future<void> wantYouGenerateAReport(context) async {
    final state = Provider.of<Database>(context, listen: false);
    if (state.path.isNotEmpty) {
      int amountOfScannedObjects = 0;
      List<DanePrzedmiotu> lackingObjects = [];
      for (int i = 0; i < state.database.length; i++) {
        if (state.database[i].stanInwentaryzaji ==
            StanInwentaryzaji.zinwentaryzowany) {
          amountOfScannedObjects++;
        } else {
          lackingObjects.add(state.database[i]);
        }
      }
      await show(
          context: context,
          title:
              "Czy ${state.path.last.nazwa} został w pełni zinwentaryzowany?",
          cancelName: "Nie",
          confirmName: "Tak",
          confirmFunction: () {
            state.path.last.stanInwentaryzaji =
                StanInwentaryzaji.zinwentaryzowany;
            state.path.last.reportData = ReportDataRoom(
                inventoryAuditor: state.user as UserData,
                objectName: state.path.last.nazwa,
                amountOfExpectedObjects: state.database.length,
                amountOfScannedObjects: amountOfScannedObjects,
                lackingObjects: lackingObjects,
                unexpectedObjects: state.path.last.nietutejszePrzedmioty);
            Navigator.of(context).pop();
          });
      if (state.path.last.stanInwentaryzaji ==
          StanInwentaryzaji.niezinwentaryzowany) {
        if (state.database.any((element) =>
            element.stanInwentaryzaji == StanInwentaryzaji.zinwentaryzowany)) {
          state.path.last.stanInwentaryzaji =
              StanInwentaryzaji.wTrakcieInwentaryzacji;
        }
      }
      if (state.path[0].stanInwentaryzaji ==
          StanInwentaryzaji.niezinwentaryzowany) {
        if (state.path[0].zawartoscPodprzedmioty.any((element) =>
            element.stanInwentaryzaji !=
            StanInwentaryzaji.niezinwentaryzowany)) {
          state.path[0].stanInwentaryzaji =
              StanInwentaryzaji.wTrakcieInwentaryzacji;
        }
      }
    }
  }

  static void scanBarcodeManual(context) {
    String? kodKreskowy;
    show(
        context: context,
        title: "Ręczne skanowanie",
        confirmFunction: () {
          Navigator.of(context).pop();
          Provider.of<Database>(context, listen: false)
              .scan(context: context, kodKreskowy: kodKreskowy);
        },
        content: CustomTextField(
          title: "Podaj kod kreskowy",
          keyboardType: TextInputType.number,
          onChanged: (value) {
            kodKreskowy = value;
            if (kodKreskowy == "") kodKreskowy = null;
          },
        ));
  }

  static Future<void> scanBarcodeNormal(context) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (barcodeScanRes != "-1") {
      Provider.of<Database>(context, listen: false)
          .scan(context: context, kodKreskowy: barcodeScanRes);
    }
  }

  static Future<bool> logOut(context) async {
    bool shouldLogOut = false;
    await show(
      context: context,
      title: "Czy chcesz się wylogować?",
      confirmFunction: () {
        Navigator.of(context).pop();
        shouldLogOut = true;
      },
      confirmName: "tak",
      cancelName: "nie",
    );
    return shouldLogOut;
  }
}
