import 'package:flutter/services.dart';
import 'package:projekt_inzynieria_oprogramowania/object_data.dart';
import 'package:projekt_inzynieria_oprogramowania/user_data.dart';
import 'package:pdf/widgets.dart' as pw;

class ReportData {
  DateTime dateTime = DateTime.now();
  UserData inventoryAuditor;

  ReportData({
    required this.inventoryAuditor,
  });

  _generator(context, ttf) {}

  Future<pw.Document> generateReportAsPDF() async {
    final customFont = await rootBundle.load("assets/font.ttf");
    final ttf = pw.Font.ttf(customFont);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return _generator(context, ttf);
        },
      ),
    );
    return pdf;
  }
}

class ReportDataRoom extends ReportData {
  String objectName;
  int amountOfScannedObjects;
  int amountOfExpectedObjects;
  List<DanePrzedmiotu> lackingObjects;
  List<DanePrzedmiotu> unexpectedObjects;

  ReportDataRoom(
      {required super.inventoryAuditor,
      required this.objectName,
      required this.amountOfExpectedObjects,
      required this.amountOfScannedObjects,
      required this.lackingObjects,
      required this.unexpectedObjects});

  @override
  String toString() {
    String report =
        "Inwentaryzację w $objectName przeprowił(a): $inventoryAuditor, dnia: ${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}\nZastano: $amountOfScannedObjects na $amountOfExpectedObjects oczekiwanych przedmiotów.\n";
    if (lackingObjects.isNotEmpty) {
      report += "Lista brakujących przedmiotów:\n";
      for (int i = 0; i < lackingObjects.length; i++) {
        report += "${lackingObjects[i]}\n";
      }
    }
    if (unexpectedObjects.isNotEmpty) {
      report += "Znaleziono następujące przedmioty:\n";
      for (int i = 0; i < unexpectedObjects.length; i++) {
        report += "${unexpectedObjects[i]}\n";
      }
    }
    return report;
  }

  @override
  List<pw.Widget> _generator(context, ttf) {
    return [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 5),
        child: pw.Text(
          "Inwentaryzację w $objectName przeprowił(a): $inventoryAuditor, dnia: ${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}\nZastano: $amountOfScannedObjects na $amountOfExpectedObjects oczekiwanych przedmiotów.\n",
          style: pw.TextStyle(font: ttf),
        ),
      ),
      if (lackingObjects.isNotEmpty)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          child: pw.Text(
            "Lista brakujących przedmiotów:\n",
            style: pw.TextStyle(font: ttf),
          ),
        ),
      if (lackingObjects.isNotEmpty)
        pw.Table.fromTextArray(
            context: context,
            data: List.generate(
                lackingObjects.length + 1,
                (index) => index == 0
                    ? ["Nazwa", "Kod kreskowy"]
                    : [
                        lackingObjects[index - 1].nazwa,
                        lackingObjects[index - 1].kodKreskowy
                      ])),
      if (unexpectedObjects.isNotEmpty)
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 5),
          child: pw.Text(
            "Znaleziono następujące przedmioty:\n",
            style: pw.TextStyle(font: ttf),
          ),
        ),
      if (unexpectedObjects.isNotEmpty)
        pw.Table.fromTextArray(
          context: context,
          data: List.generate(
              unexpectedObjects.length + 1,
              (index) => index == 0
                  ? ["Nazwa", "Kod kreskowy", "Pochodzenie"]
                  : [
                      unexpectedObjects[index - 1].nazwa,
                      unexpectedObjects[index - 1].kodKreskowy,
                      unexpectedObjects[index - 1].pochodzenie,
                    ]),
        ),
    ];
  }
}

class ReportDataBuilding extends ReportData {
  List<ReportDataRoom> roomsInBuilding;
  String objectName;

  ReportDataBuilding({
    required this.roomsInBuilding,
    required super.inventoryAuditor,
    required this.objectName,
  });

  @override
  String toString() {
    String report =
        "Inwentaryzację w $objectName przeprowił(a): $inventoryAuditor, dnia: ${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}\n";
    for (int i = 0; i < roomsInBuilding.length; i++) {
      report += "${roomsInBuilding[i]}\n";
    }
    return report;
  }

  @override
  List<pw.Widget> _generator(context, ttf) {
    List<pw.Widget> result = [];
    result.add(
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 5),
        child: pw.Text(
          "Inwentaryzację w $objectName przeprowił(a): $inventoryAuditor, dnia: ${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}\n",
          style: pw.TextStyle(font: ttf),
        ),
      ),
    );
    roomsInBuilding.forEach((element) {
      element._generator(context, ttf).forEach((element) {
        result.add(element);
      });
    });
    return result;
  }
}

class ReportDataAll extends ReportData {
  List<ReportDataBuilding> buildings;

  ReportDataAll({
    required this.buildings,
    required super.inventoryAuditor,
  });

  @override
  String toString() {
    String report =
        "Inwentaryzację sfinalizował(a): $inventoryAuditor, dnia: ${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}\n";
    for (int i = 0; i < buildings.length; i++) {
      report += "${buildings[i]}\n\n";
    }
    return report;
  }

  @override
  List<pw.Widget> _generator(context, ttf) {
    List<pw.Widget> result = [];
    result.add(
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 5),
        child: pw.Text(
          "Inwentaryzację sfinalizował(a): $inventoryAuditor, dnia: ${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}\n",
          style: pw.TextStyle(font: ttf),
        ),
      ),
    );
    buildings.forEach((element) {
      element._generator(context, ttf).forEach((element) {
        result.add(element);
      });
    });
    return result;
  }
}
