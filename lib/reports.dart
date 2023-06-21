import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/alert.dart';
import 'package:projekt_inzynieria_oprogramowania/database.dart';
import 'package:projekt_inzynieria_oprogramowania/report_data.dart';
import 'package:provider/provider.dart';
import 'custom_floating_action_button.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _Reports();
}

class _Reports extends State<Reports> {
  List<List<ReportData>> _currentReportsList = [];

  @override
  void initState() {
    //tu docelowo wczytujemy baze raportów do aplikacji
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<Database>(context, listen: false);
      setState(() {
        _currentReportsList.add(state.reports);
        _currentReportsList.last = _currentReportsList.last.reversed.toList();
      });
    });
    super.initState();
  }

  void showPDF(pw.Document pdf,String aboutDocument) async {
    final dd = await pdf.save();
    Future(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      final file = File(
                          "/storage/emulated/0/Download/$aboutDocument.pdf"); //docelowo nazwa powinna zawierać informacje o dokumencie
                      await file.writeAsBytes(await pdf.save()); //pobierz pdf
                      Future(() {
                        Alert.communique(context, "Pobrano raport");
                      });
                    },
                    icon: const Icon(Icons.download))
              ],
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
              title: const Text(
                "Podgląd raportu",
                textAlign: TextAlign.center,
              ),
            ),
            body: PDFView(
              pdfData: dd,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _currentReportsList.removeLast();
        });
        if (_currentReportsList.isEmpty) {
          return true;
        }
        return false;
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
          title: const Text(
            "Raporty",
            textAlign: TextAlign.center,
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
          ), //odwołanie do parametru title
        ),
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width, //szerokość ekranu
            height: MediaQuery.of(context).size.height, //wysokość ekranu
            child: ListView(
              //skrolowalna lista
              children: List.generate(
                _currentReportsList.isEmpty
                    ? 0
                    : _currentReportsList.last.length,
                (index) => GestureDetector(
                  onTap: () {
                    if (_currentReportsList.length == 1) {
                      setState(() {
                        _currentReportsList.add(
                            (_currentReportsList.last[index] as ReportDataAll)
                                .buildings);
                      });
                    } else {
                      if (_currentReportsList.length == 2) {
                        setState(() {
                          _currentReportsList.add((_currentReportsList
                                  .last[index] as ReportDataBuilding)
                              .roomsInBuilding);
                        });
                      } else {
                        Alert.communique(context,
                            "Nie ma mniejszego elementu. Przytrzymaj aby wygenerować raport");
                      }
                    }
                  },
                  onLongPress: () async {
                    showPDF(
                        await _currentReportsList.last[index].generateReportAsPDF(),
                      "${_currentReportsList.last[index].dateTime.year}-${_currentReportsList.last[index].dateTime.month.toString().padLeft(2, '0')}-${_currentReportsList.last[index].dateTime.day.toString().padLeft(2, '0')}_${_currentReportsList.length == 1 ? "Raport_Ogolny"
                            : _currentReportsList.length == 2
                        ? "Raport_Budynku_${(_currentReportsList.last[index] as ReportDataBuilding).objectName}"
                            : "Raport_Pokoju_${(_currentReportsList.last[index] as ReportDataRoom).objectName}"}"

                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                      //gradient: LinearGradient(colors: [Colors.lightGreen,Colors.lightGreenAccent],stops: [0.6,1]),//alternatywnie można poeksepymentować z gradentem by lepie to wyglądało
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset(3, 3),
                            blurRadius: 3),
                        BoxShadow(
                            color: Colors.white10,
                            offset: Offset(-2, -2),
                            blurRadius: 2)
                      ],
                      //cień na dole, światło na górze, można poeksperymentować bybyło lepiej
                      color: Colors.lightGreen,
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
                            child: Center(
                              child: Text(
                                _currentReportsList.length == 1
                                    ? "Raport z inwentaryzacji zakończonej dnia: ${_currentReportsList.last[index].dateTime.day.toString().padLeft(2, '0')}.${_currentReportsList.last[index].dateTime.month.toString().padLeft(2, '0')}.${_currentReportsList.last[index].dateTime.year}"
                                    : _currentReportsList.length == 2
                                        ? "Raport budynku: ${(_currentReportsList.last[index] as ReportDataBuilding).objectName}"
                                        : "Raport pokoju: ${(_currentReportsList.last[index] as ReportDataRoom).objectName}",
                                style: const TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), //generator elementów (wizualnych) listy),
            ),
          ),
        ),
        floatingActionButton: CustomFloatingActionButton(
          iconData: Icons.content_paste_search,
          function: () async {},
        ),
      ),
    );
  }
}
