import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model extends ChangeNotifier{

  List<Map<String,dynamic>> data;
  Model({ required this.data});

  Future<void> obtenirData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String ? jsonString = prefs.getString("data");
    if(jsonString != null){
      List<dynamic> jsonList = jsonDecode(jsonString);
      data = jsonList.map((item) => Map<String,dynamic>.from(item)).toList();
      
      notifyListeners();
    }
 
  }

  enregistrer(newdata) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    data.insert(0, newdata);
    String jsonString = jsonEncode(data);
    await prefs.setString('data', jsonString);
    obtenirData();
  }

  deleteOne(List deleteData) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    data.removeWhere((item) => deleteData.contains(item));
    String jsonString = jsonEncode(data);
    await prefs.setString('data', jsonString);
    obtenirData();
  }

  supprimer()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    data.clear();
    await prefs.remove('data');
    obtenirData();
  }
  
}

final obtenir = ChangeNotifierProvider<Model>((ref){
  return Model(data: []);
});
final exopra = StateProvider<String>((ref){
  return "";
});
final exsol = StateProvider<String>((ref){
  return "";
});
final positions = StateProvider<bool>((ref){
  return true;
});
