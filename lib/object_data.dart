import 'package:projekt_inzynieria_oprogramowania/report_data.dart';

enum StanInwentaryzaji {
  niezinwentaryzowany,
  wTrakcieInwentaryzacji,
  zinwentaryzowany
}

class DanePrzedmiotu {
  String? kodKreskowy;
  String nazwa;
  StanInwentaryzaji stanInwentaryzaji = StanInwentaryzaji.niezinwentaryzowany;
  List<DanePrzedmiotu> zawartoscPodprzedmioty;
  List<DanePrzedmiotu> nietutejszePrzedmioty = [];
  ReportData? reportData;
  String? pochodzenie;//z jakego pomieszczenia jest przedmiot - ustawiane gdy znaleziono coś nie na miejscu.

  DanePrzedmiotu(
      {required this.nazwa,
      this.kodKreskowy,
      required this.zawartoscPodprzedmioty,
      this.pochodzenie});
  @override
  String toString() {
    return "$nazwa\t$kodKreskowy";
  }
}
