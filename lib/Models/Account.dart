
abstract class Account {
  String _name;
  String _email;
  String _password;


  Account({String name, String email, String password}){
    this._email = email;
    this._password = password;
    this._name = name;
  }

  Future<void> login();
  Future<void> logout();
  Future<void> register();
  Future<void> forgotPassword();

  String getName() => _name ?? '';

  setName(String value) {
    _name = value;
  }

  String getPassword() => _password ?? '';

  setPassword(String value) {
    _password = value;
  }

  String getEmail() => _email ?? '';

  setEmail(String value) {
    _email = value;
  }

}
