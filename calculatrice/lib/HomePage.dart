
import 'package:calculatrice/CalStandard.dart';
import 'package:calculatrice/Drawer.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomepageState();
}


class HomepageState extends State<HomePage> {

  
  @override
  Widget build(BuildContext context) {
    //Orientation orientation = MediaQuery.of
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Created by Denilson"),
        centerTitle: true,
        backgroundColor: Colors.black,
        titleTextStyle: TextStyle(color: Colors.amber[800]),
        iconTheme: IconThemeData(color: Colors.amber[800]),
      ),
      drawer: const Drawer(child: Drawers()),
      body: const Calstandard(),
      
    );
  }
  /*obtenir() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String ? jsonString = prefs.getString("data");
    if(jsonString != null){
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<Map<String,dynamic>> dataf = jsonList.map((item) => Map<String,dynamic>.from(item)).toList();
      setState(() {
       // data = dataf;
       });
    }
   return null;
 
  }*/

}