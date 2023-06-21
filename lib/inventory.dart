import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/alert.dart';
import 'package:projekt_inzynieria_oprogramowania/object_data.dart';
import 'package:projekt_inzynieria_oprogramowania/report_data.dart';
import 'package:projekt_inzynieria_oprogramowania/user_data.dart';
import 'package:provider/provider.dart';
import 'database.dart';
import 'element_of_database.dart';
import 'custom_floating_action_button.dart';

class Inventory extends StatefulWidget {
  //ze stanem - dynamiczny obraz który możemy odświerzać.
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _Inventory();
}

class _Inventory extends State<Inventory> {
  bool photoScanner = true;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<Database>(context,
        listen:
            true); //zmienna do zarządania stanem aplikacji (potrzebne by wyświetlały się aktualne dane)

    return WillPopScope(
      onWillPop: () async {
        if (state.path.isNotEmpty) {
          if (state.path.length == 2) {
            await Alert.wantYouGenerateAReport(context);
            if (state.path.last.stanInwentaryzaji ==
                StanInwentaryzaji.zinwentaryzowany) {
              String localization = state.path.last.nazwa;
              Future(() {
                Alert.communique(
                    context, "Zakończono inwentaryzację $localization.");
              });
            }
          } else {
            if (state.path.length == 1 &&
                state.database.every((element) =>
                    element.stanInwentaryzaji ==
                    StanInwentaryzaji.zinwentaryzowany)) {
              state.path.last.stanInwentaryzaji =
                  StanInwentaryzaji.zinwentaryzowany;
              List<ReportDataRoom> rooms = [];
              for (int i = 0; i < state.database.length; i++) {
                rooms.add(state.database[i].reportData as ReportDataRoom);
              }
              state.path.last.reportData = ReportDataBuilding(
                  roomsInBuilding: rooms,
                  inventoryAuditor: state.user as UserData,
                  objectName: state.path.last.nazwa);
              String localization = state.path.last.nazwa;
              Future(() {
                Alert.communique(
                    context, "Zakończono inwentaryzację $localization.");
              });
            }
          }
          state.pathPrevious();
          return false;
        }
        if (state.database.every((element) =>
            element.stanInwentaryzaji == StanInwentaryzaji.zinwentaryzowany)) {
          List<ReportDataBuilding> buildings = [];
          for (int i = 0; i < state.database.length; i++) {
            buildings.add(state.database[i].reportData as ReportDataBuilding);
          }
          state.reports.add(ReportDataAll(
              buildings: buildings, inventoryAuditor: state.user as UserData));
          Future(() {
            Alert.communique(context, "Sfinalizowano inwentaryzację.");
          });
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
            state.title,
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
                        function: () {
                          Alert.communique(context,
                              "${state.database[index].nazwa} został już zinwentaryzowany");
                        },
                      )), //generator elementów (wizualnych) listy),
            ),
          ),
        ),
        floatingActionButton: state.path.length == 2
            ? photoScanner
                ? CustomFloatingActionButton(
                    iconData: Icons.photo_camera_outlined,
                    function: () async {
                      await Alert.scanBarcodeNormal(context);
                    },
                    onDoubleTap: () {
                      setState(() {
                        photoScanner = !photoScanner;
                      });
                    },
                  )
                : CustomFloatingActionButton(
                    iconData: Icons.search,
                    function: () {
                      Alert.scanBarcodeManual(context);
                    },
                    onDoubleTap: () {
                      setState(() {
                        photoScanner = !photoScanner;
                      });
                    },
                  )
            : null,
        //MultiToolsFloatingActionButton(editMode: false,),
      ),
    );
  }
}
