import 'package:flutter/cupertino.dart';

class SearchProvider extends ChangeNotifier{
  bool isSearching =false;

  updateController(bool state){
    isSearching = state;
    notifyListeners();
  }
}