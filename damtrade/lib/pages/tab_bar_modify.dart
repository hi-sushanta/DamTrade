

import 'package:flutter/material.dart';
import 'home.dart';
import 'auth_gate.dart';
import '../main.dart';
// void main() => runApp(
//   const TabBarDesging()
//   );

// ignore: must_be_immutable
late TextEditingController _searchController;

class TabBarDesging extends StatelessWidget {

  int? index;  
  TabBarDesging(int this.index, {Key? key}) : super(key: key);

  
  
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
                debugPrint("WatchList:${watchlist!.data['data']![userId]![0][this.index]}, _searchControll: ${_searchController.text}");
                watchlist!.data["data"]![userId]![0][this.index!] = _searchController.text;
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

    return Row(children: [
      SizedBox(
      width: 250,
      child: 
        TextField(
        // obscureText: true,
        controller: _searchController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      ),
           ], 
         
     
    );
  
 }
}

