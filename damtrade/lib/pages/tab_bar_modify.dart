

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'home.dart';
import 'auth_gate.dart';
import '../main.dart';
// void main() => runApp(
//   const TabBarDesging()
//   );

// ignore: must_be_immutable
late TextEditingController _searchController;

class TabBarDesging extends StatelessWidget {

  final int index;
  final Function(String) onSave;
  TabBarDesging(this.index, {Key? key, required this.onSave}) : super(key: key);

  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Watchlist"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Add back button functionality
            },
          ),
          actions: [
            TextButton(onPressed: (){
              if (_searchController.text.isNotEmpty){
                onSave(_searchController.text);
              }
              Navigator.pop(context);
            }, child: Text("Save",style: TextStyle(color: Colors.black,fontSize: 18.0)),
    
            ),

          ],
          
        ),
        body: TabPage(index), // Replace with your actual class name
      ),
    );
  }
}


// ignore: must_be_immutable
class TabPage extends StatefulWidget {

  int? index;
  TabPage(this.index);

  @override
  _TabBarState createState() => _TabBarState(index);
}

class _TabBarState extends State<TabPage> with TickerProviderStateMixin{
  // ignore: recursive_getters
    int? index;

    _TabBarState(this.index);
    //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  
  @override
  void initState() {
    _searchController = TextEditingController(text: watchlist!.data["data"]![userId]![0][this.index!]);

    super.initState();
  }
  
 

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            
            controller: _searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.edit),
              border: OutlineInputBorder(
              borderSide: BorderSide(width: 0),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),

              hintText: 'Enter a search term',
            ),
          ),
        ),
        

        Expanded(
          
          child:ReorderableListView(
                                
                              
                                children:[ 
                                  // for (String item in watchlist!.data["data"]![userId]![this.index!+1])
                                  for (int i = 0; i < watchlist!.data["data"]![userId]![this.index! + 1].length; i++)
                                  // watchlist!.data['data']![userId]![this.index!+1].toList().asMap().forEach((index,item) => {

                                      Card(
                                      key: ValueKey<String>(watchlist!.data["data"]![userId]![this.index! + 1][i]),
                                      color: Colors.green[50],
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                                      child: Row(
                                        children: [
                                          // Padding(
                                          // padding: EdgeInsets.all(8.0),
                                          Expanded(
                                            flex: 2,
                                            child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                          
                                                  child: Text(watchlist!.data["data"]![userId]![this.index! + 1][i]),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                                                  child: Text(
                                                    watchlist!.data["data"]![userId]![this.index! + 1][i] ,
                                                    style: const TextStyle(fontSize: 12.0, color: Colors.grey), // Adjust description style
                                                  ),
                                                ),
                                              ],
        
                                                ),
                                            ),
                                          //  ), // Left text takes 2/6 of space
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,

                                              crossAxisAlignment: CrossAxisAlignment.end, // Align texts to right
                                              children: [
                                                IconButton(onPressed: (){
                                                  setState(() {
                                                      watchlist!.data['data']![userId]![this.index!+1].removeAt(i);
                                                  });

                                                }, icon: Icon(Icons.delete))
                                              ]
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                      )
                                  // }),

                                      // ),

                                ],
                                onReorder: (oldIndex, newIndex) => {},
                              ),
        ),

      ],
    );

  
 }
}

