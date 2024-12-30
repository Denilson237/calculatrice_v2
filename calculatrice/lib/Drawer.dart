
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calculatrice/riverpod.dart';
import 'package:flutter/material.dart';


class Drawers extends ConsumerStatefulWidget {
  const Drawers({super.key});

  @override
  DrawersState createState() => DrawersState();
}

class DrawersState extends ConsumerState<Drawers> {

  
  
  @override
  void initState(){
  super.initState();
}
  String operation = '';
  String solution = "0";
  int count = 0;
  bool afficheSupp = false;
  List deleteData = [];

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(obtenir).data;
    count = data.where((items) => (items["chek"] == true)).length;
    
    return Scaffold(
      
          backgroundColor: Colors.grey[900],
          body: Stack(
            
            children: [
              //////////////////////////////// page de fond ///////////////////////////////////////////////////////////
             data.isEmpty ? Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time, color: Colors.grey[500],size: 30,),
                          const SizedBox(height: 6,),
                          Text("Aucun historique", style: TextStyle(color: Colors.grey[500] , fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
              )
                
            ):const SizedBox() ,
            //////////////////////////////////////////// appbar ////////////////////////////////////////////////////////
                  Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        
                      decoration: BoxDecoration(
                          color: Colors.grey[900],
                            border: data.isNotEmpty ? Border(
                                bottom: BorderSide(
                                    color: Colors.grey[400]!, width: 0.3)): null),
                        
                        padding: EdgeInsets.zero,
                        height: MediaQuery.of(context).size.height / 7.9,
                        alignment: Alignment.bottomLeft,
                        child: ListTile(
                          leading: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Icon(
                                Icons.menu,
                                color: Colors.orange[500],
                              )),
                          trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  afficheSupp = !afficheSupp;
                                });
                              },
                              child: afficheSupp 
                                  ? action(data) :
                                   data.isNotEmpty
                                  ? Text(
                                      "Modifier",
                                      style: TextStyle(
                                          color: Colors.orange[400],
                                          fontSize: 15),
                                    ):const SizedBox()),
                        ),
                      )
                    ),

//////////////////////////////////// liste d'elements //////////////////////////////////////////////////////////
              Positioned(
                top: 118,
                left: 0,
                right: 0,
                bottom: 0,
                child: 
                ListView.builder(

                  padding: const EdgeInsets.only(bottom: 94),
                  itemCount: data.length ,
                  itemBuilder: (context, i) {
                    //data[i]['chek'] == true? count ++: "";
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[400]!, width: 0.3))),
                        child: ListTile(
                          title: Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 8),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                data[i]['operations'],
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 14),
                              ),
                            ),
                          ),
                          subtitle: Container(
                            margin: const EdgeInsets.only(bottom: 7),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(data[i]['solutions'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 19)),
                            ),
                          ),
                          leading: afficheSupp
                              ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      color: data[i]['chek']? Colors.white: Colors.grey[900],
                                      shape: BoxShape.circle
                                    ),
                                    ),

                                    GestureDetector(
                                      child: data[i]['chek']? Icon(Icons.check_circle , color: Colors.orange[400],): const Icon(Icons.circle_outlined,),
                                      onTap: (){
                                        setState(() {
                                          data[i]['chek'] = !data[i]['chek'];
                                          data[i]['chek'] == true? deleteData.add(data[i]):  deleteData.remove(data[i]);
                                        });
                                      },
                                    ),
                                  
                                ],
                              )
                             
                              : null,
                        onTap: () {
                          if(!afficheSupp){
                              operation = data[i]['operations'];
                              solution = data[i]['solutions'];
                              ////////////////////////////////////////// riverpod /////////////////////
                              ref.read(exopra.notifier).state = operation;
                              ref.read(exsol.notifier).state = solution;
                              Navigator.pop(context);
                              }else{
                                setState(() {
                              data[i]['chek'] = !data[i]['chek'];
                              data[i]['chek'] == true? deleteData.add(data[i]): deleteData.remove(data[i]);
                              
                            });
                              }
                          },
                        ),
                        
                      );
                    }
                  ),),
                  /////////////////////////////////////// bottom sheet //////////////////////////////////
              data.isNotEmpty && afficheSupp
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[900],
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey[400]!, width: 0.3))),
                        height: MediaQuery.of(context).size.height / 10,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    //deleteOne(deleteData);
                                    modal(count);
                                  });
                                },
                                child: Text(
                                  count > 0 ? "Supprimer($count)" : " ",
                                  style: TextStyle(
                                      color: Colors.orange[400], fontSize: 15),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    modal("tout supprimer");
                                  });
                                },
                                child: 
                                Text(
                                  "Tout supprimer",
                                  style
                                  : TextStyle(
                                      color: Colors.orange[400], fontSize: 15),
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  :const SizedBox(),

            ],
          ));
    
  }
  
  modal(number){
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context, 
      builder: (BuildContext context){
        return Container(
          margin: const EdgeInsets.all(15),
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              Container(
                decoration:  BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                  
                ),
                width: double.infinity,
                height: 120,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey[400]!, width: 0.3)),
                      ),
                      child: 
                      Text( number == "tout supprimer"? "Tous les calculs seront supprimés. Cette action est irréversible.":
                      number == 1?  "Ce calcul sera supprimé. Cette action est irréversible.":
                      "Ces $number calculs seront supprimé. Cette action est irreversible.",
                      
                      style: const TextStyle(fontSize: 13,color:  Colors.white), textAlign: TextAlign.center,)
                      
                      ),
                    
                    InkWell(
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: Text(number == "tout supprimer"? "Tout supprimer": "Supprmer", style: const TextStyle(color:  Colors.red, fontSize: 17)),
                      ),
                      onTap: (){
                              number == "tout supprimer"?
                              setState(() {
                                Navigator.pop(context);
                                supprimer();
                              afficheSupp = !afficheSupp;
                              
                              })
                              : setState(() {
                                 Navigator.pop(context);
                                deleteOne(deleteData);
                              });
                              
                              
                            },
                    ),
                  ],
                  
                ),
              ),
              const SizedBox(height: 8, width: double.infinity,),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 50,
                  decoration:  BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Annuler", style: TextStyle(color:  Colors.blue, fontSize: 17)),
                ),
                onTap: (){
                        setState(() {
                          Navigator.pop(context);
                        });
                        
                      },
              ),
        
            ],
          ),
        );
      });
  }

  action(data) {
    return GestureDetector(
        onTap: () {
          setState(() {
            for (var item in data) {
              item["chek"] = false;
            }
            count = 0;
            afficheSupp = !afficheSupp;
          });
        },
        child: Text(
          "OK",
          style: TextStyle(color:  Colors.orange[400], fontSize: 16),
        ));
  }

  

  deleteOne(deleteData) async{
    ref.read(obtenir).deleteOne(deleteData);
  }
  

  supprimer() async{
    ref.read(obtenir).supprimer();
  }

}