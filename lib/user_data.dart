enum AccessLevel { readOnly, edit }

class UserData {
  String login;
  late String _password; //Ja wiem że to złe ;)
  String name;
  String surname;
  AccessLevel accessLevel;

  UserData({
    required this.login,
    required password,
    required this.name,
    required this.surname,
    required this.accessLevel,
  }) {
    _password = password;
  }

  bool isPasswordCorrect(String login, String password) {
    if (password == _password && login == this.login) {
      return true;
    }
    return false;
  }
  @override String toString() {
    return "$name $surname";
  }
}
