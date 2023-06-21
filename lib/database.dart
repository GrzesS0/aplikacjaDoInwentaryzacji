import 'package:flutter/material.dart';
import 'package:projekt_inzynieria_oprogramowania/alert.dart';
import 'package:projekt_inzynieria_oprogramowania/object_data.dart';
import 'package:projekt_inzynieria_oprogramowania/report_data.dart';
import 'package:projekt_inzynieria_oprogramowania/user_data.dart';

class Database extends ChangeNotifier {
  //używamy tej klasy by nie mieć problemu z aktualizacją stanu aplikacji (używamy provider'a dzięki któremu pół-automatycznie zmienia się wyświetlany stan aplikacji)
  final List<DanePrzedmiotu> _path =
      []; //ścieżka dostępu do bierzącego miejsca (np. Budynek 3, Pokój 7) - Przetrzymuje referencje do tych objektów
  List<DanePrzedmiotu> _database = []; //to jest cała nasza baza danych
  UserData? user;
  bool isAccessToEdit = false;
  List<ReportDataAll> reports = [];

  List<DanePrzedmiotu> get path => _path;

  String get title {
    //zwraca tytuł bierzącej strony
    if (path.isEmpty) {
      return "Inwentaryzacja";
    } else {
      String title = "";
      for (int i = 0; i < path.length; i++) {
        if (title != "") {
          title += ", ";
        }
        title += path[i].nazwa;
      }
      return title;
    }
  }

  List<DanePrzedmiotu> get database {
    //zwraca bierzący fragment bazy danych
    if (path.isEmpty) {
      return _database;
    } else {
      return path.last.zawartoscPodprzedmioty;
    }
  }

  set database(List<DanePrzedmiotu> value) {
    //to nie powinno być używane zbyt często - nadpisuje całą baze danych i wysła komunikat o zmianie do wszystkich słuchaczy
    _database = value;
    notifyListeners(); //dzięki temu aktualizuje się wyświetlany obraz
  }

  void add(DanePrzedmiotu danePrzedmiotu,BuildContext context) {
    //dodaje nowy element do bazy danych w bierzącym kontekście (np. w wybranym Budynku)
    if (danePrzedmiotu.kodKreskowy != null &&
        deepSearch(danePrzedmiotu.kodKreskowy as String) != null) {
      Alert.communique(context, "Ten kod kreskowy jest już używany");
    } else {
      if (path.isEmpty) {
        _database.add(danePrzedmiotu);
      } else {
        path.last.zawartoscPodprzedmioty.add(danePrzedmiotu);
      }
      notifyListeners();
    }
  }

  void pathAdd(DanePrzedmiotu danePrzedmiotu) async {
    //dodaje element do ścieżki
    _path.add(danePrzedmiotu);
    notifyListeners();
  }

  void pathPrevious() {
    //usuwa element ze ścieżki
    _path.removeLast();
    notifyListeners();
  }

  void delete({required int index}) {
    if (index >= 0 && index < database.length) {
      database.removeAt(index);
      notifyListeners();
    }
  }

  void edit({
    required int index,
    String? nazwa,
    String? kodKreskowy,
    int? oczekiwanaIlosc,
    int? zastanaIlosc,
  }) {
    //tu dodać edycje
    if (nazwa != null) {
      database[index].nazwa = nazwa;
    }
    if (kodKreskowy != null) {
      database[index].kodKreskowy = kodKreskowy;
    }
    notifyListeners();
  }

  DanePrzedmiotu? deepSearch(String kodKreskowy) {
    for (int i = 0; i < _database.length; i++) {
      for (int j = 0; j < _database[i].zawartoscPodprzedmioty.length; j++) {
        for (int k = 0;
            k <
                _database[i]
                    .zawartoscPodprzedmioty[j]
                    .zawartoscPodprzedmioty
                    .length;
            k++) {
          if (_database[i]
                  .zawartoscPodprzedmioty[j]
                  .zawartoscPodprzedmioty[k]
                  .kodKreskowy ==
              kodKreskowy) {
            _database[i]
                .zawartoscPodprzedmioty[j]
                .zawartoscPodprzedmioty[k].pochodzenie = "${_database[i].nazwa}, ${_database[i].zawartoscPodprzedmioty[j].nazwa}";
            return _database[i]
                .zawartoscPodprzedmioty[j]
                .zawartoscPodprzedmioty[k];
          }
        }
      }
    }
    return null;
  }

  void scan({String? kodKreskowy, int? index, context}) {
    if (kodKreskowy != null) {
      for (int i = 0; i < database.length; i++) {
        if (database[i].kodKreskowy == kodKreskowy) {
          if (database[i].stanInwentaryzaji ==
              StanInwentaryzaji.zinwentaryzowany) {
            Alert.communique(context, "${database[i].nazwa} był już skanowany");
            notifyListeners();
            return;
          }
          Alert.communique(context, "Zeskanowano ${database[i].nazwa}");
          database[i].stanInwentaryzaji = StanInwentaryzaji.zinwentaryzowany;
          notifyListeners();
          return;
        }
      }
      DanePrzedmiotu? foundObject = deepSearch(kodKreskowy);
      path.last.nietutejszePrzedmioty.add(foundObject ??
          DanePrzedmiotu(
              nazwa: "niezidentyfikowany przedmiot",
              zawartoscPodprzedmioty: [],
              kodKreskowy: kodKreskowy,
          pochodzenie: "nieznane"));

      if (foundObject == null) {
        Alert.communique(context, "Zeskanowano niezidentyfikowany przedmiot");
      } else {
        Alert.communique(
            context, "Zeskanowano ${foundObject.nazwa} z innego pokoju");
      }
    }
    if (index != null && database[index].zawartoscPodprzedmioty.isEmpty) {
      database[index].stanInwentaryzaji = StanInwentaryzaji.zinwentaryzowany;
    }
    notifyListeners();
  }
}
