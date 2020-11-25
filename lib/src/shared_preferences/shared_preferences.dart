import 'package:shared_preferences/shared_preferences.dart';

class SavedData{

  static final SavedData _instancia = new SavedData._internal();

  factory SavedData(){
    return _instancia;
  }

  SavedData._internal();

  SharedPreferences _prefs;

  initPrefs() async {

    this._prefs = await SharedPreferences.getInstance();
  }

  // GET & SET for scanResult

  get scanResult{
    return _prefs.getString('scanResult') ?? '';
  }

  set scanResult(String value){
    _prefs.setString('scanResult', value);
  }

  // GET & SET for refreshToken

  get refreshToken{
    return _prefs.getString('refreshToken') ?? '';
  }

  set refreshToken(String value){
    _prefs.setString('refreshToken', value);
  }

  // GET & SET for expDate

  get expDate{
    return _prefs.getString('expDate') ?? '';
  }

  set expDate(String value){
    _prefs.setString('expDate', value);
  }
}