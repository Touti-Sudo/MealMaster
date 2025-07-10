import 'package:flutter/material.dart';
import 'package:login/theme/theme.dart';


class Themeprovider with ChangeNotifier {
  ThemeData _themeData=lightmode;
  ThemeData get themeData => _themeData;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

void toggeletheme(){
  if (_themeData ==lightmode) {
    themeData = darkmode;
  }else {
    themeData = lightmode;
  }
}



}