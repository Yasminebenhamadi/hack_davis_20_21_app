class User{
  String _userID;
  String _name;
  int _age;
  DateTime _birthday;
  List<String> _hobbies;
  List<String> _connections;
  final String _uidKey = 'UID';
  final String _nameKey = 'Name';
  final String _ageKey = 'Age';
  final String _birthdayKey = 'DateOfBirth';
  final String _hobbiesKey = 'Hobbies';
  final String _connectionsKey = 'Connections';

  User(this._userID,this._name,this._age,this._birthday,){
    _hobbies = List<String> ();
    _connections = List<String> ();
  }
  User.fromMap (Map<String,dynamic> userInfo){
    _userID = userInfo[_uidKey];
    _name = userInfo[_nameKey];
    _age = userInfo[_ageKey];
    _birthday = userInfo[_birthdayKey];
    _hobbies = userInfo[_hobbiesKey];
    _connections = userInfo[_connectionsKey];
  }
  Map<String,dynamic> userToMap (){ //Use this this save user's info in fire_store
    return {
      _uidKey: _userID,
      _nameKey: _name,
      _ageKey: _age,
      _birthdayKey: _birthday,
      _hobbiesKey: _hobbies,
      _connectionsKey : _connectionsKey,
    };
  }

  String get name => _name;

  String get userID => _userID;

  int get age => _age;

  DateTime get birthday => _birthday;

  List<String> get connections => _connections;

  List<String> get hobbies => _hobbies;

}