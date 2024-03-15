import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_list/todo_model.dart';

class HttpService extends ChangeNotifier{
 String url = "https://jsonplaceholder.typicode.com/todos";
 List<TodoModel> todoModelList = [];
 bool isLoading = true;
 Future<List<TodoModel>> getTodoList() async{

   var response = await http.get(Uri.parse(url));
   if(response.statusCode == 200){
     var data = json.decode(response.body);
   print(data);
     todoModelList = data.map<TodoModel>((e)=>TodoModel.fromJson(e)).toList();
     isLoading = false;
     notifyListeners();
     return todoModelList;
   }
   else{
     isLoading = false;
     todoModelList = [];
     notifyListeners();
     return todoModelList;
   }
 }
}