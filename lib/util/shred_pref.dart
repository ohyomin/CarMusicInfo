import 'package:shared_preferences/shared_preferences.dart';

class Pref {

  late SharedPreferences pref;

  static final Pref _instance = Pref._();

  static const _scale = 'scale';

  Pref._();

  factory Pref() => _instance;

  Future<void> init() async {
    pref = await SharedPreferences.getInstance();
  }

  void putScaleIndex(int index) {
    pref.setInt(_scale, index);
  }

  int getScaleIndex() {
    return pref.getInt(_scale) ?? 0;
  }
}