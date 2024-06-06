import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import "package:flutter/widgets.dart";
import "tab_bar_modify.dart";
import 'watch_list_info.dart';
import 'auth_gate.dart';
import '../main.dart';
import 'stock_service.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:math';
import 'search_bar_desgine.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;



// final WatchlistItem watchlist = WatchlistItem(userId);

// void main() async{
  
//   WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();

//   runApp(const Home());
// }




class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // Replace with your actual class name
    );
  }

}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
    //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  int _selectedIndex = 0; // Track the selected index for the navigation bar

  final List<Widget> _pages = [
    BaseHome(), // Replace with your content widget for Home
    SecondPageContent(), // Replace with your content widget for second tab
    ThirdPageContent(), // Replace with your content widget for third tab
    FourthPageContent(), // Replace with your content widget for fourth tab
  ];
  
  

  @override
  Widget build(BuildContext context) {
    final counterRef = FirebaseFirestore.instance.collection(userId);
    return Scaffold(
        body: _pages[_selectedIndex], // Display content based on selected index
        bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
      
        },
        indicatorColor: Colors.amber,
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket_sharp),
            label: 'Busket',
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm),
            label: 'Alart',
          ),
          NavigationDestination(
            icon:Icon(Icons.info), 
            label: "Account")
        ],
        
      ), 
       
    );
  }

  
}

class BaseHome extends StatefulWidget {
  @override
  HomePageBar createState() => HomePageBar();
}

class HomePageBar extends State<BaseHome> with TickerProviderStateMixin{
  late TabController _tabController;
  late List? item;
  int index = 0;
  Timer? _timer;


  final TextEditingController _searchController = TextEditingController();
  // var titles = ["watchlist1","watchlist2","watchlist3","watchlist4","watchlist5","watchlist6","watchlist7","watchlist8",'watchlist9',"watchlist10"];
  List<String>price_info = ["7.10","0.53%","^","1337.50"];
  List<Map<String,Map<String,String>>> stockData = [];
  late Map<String,List<String>> watchListItem;
    // Define a method to refresh the state
  @override
  void initState() {
    super.initState();
      item = nameWatchlist();
      watchListItem = getItem();
      // debugPrint("Hellow It's done");
      _tabController = TabController(length: watchlist!.data['data']![userId]![0].length, vsync: this);
      
      _startFetchingStockData();

  }


  int get tabControllerLength => watchlist!.data["data"]![userId]![0].length;

  
  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();

    super.dispose();

  }
  
  List nameWatchlist(){
    List<String> demoitem = [];
    for (int i=0; i < 10; i++){
      demoitem.add(watchlist!.data["data"]![userId]![0][i].toString());
    }
    return demoitem;
  }

  Map<String,List<String>> getItem(){
    Map<String,List<String>> stock = {};
    for (int i=0; i<10; i++){
      List<String> demoitem  = [];
      for (String it in watchlist!.data['data']![userId]![i+1]){
        demoitem.add(it.toUpperCase());
      }
      stock[watchlist!.data['data']![userId]![0][i]] = demoitem;
    }

    return stock;
  }


  void _startFetchingStockData() async {
        await _updateStockData();
  }

  Future<void> _updateStockData() async {
    List<Map<String,Map<String,String>>> updatedStockData = [];

    try {
      for (var watchName in watchListItem.keys) {
        Map<String,Map<String,String>>stockInfo = {};
        for (var stock in watchListItem[watchName]!) {
          String istock = stock.split("+")[0];
          Map<String,String> data = await fetchStockData(istock);
          stockInfo[stock]= data;
        }
        updatedStockData.add(stockInfo);
      }

      setState(() {
        stockData =  updatedStockData;
      });
    } catch (e) {
      print('Error updating stock data: $e');

    }
  }

  

  void updateMyWatchList(int oldIndex,int newIndex,index){
    setState(() {
      // an adjustment is needed when moving the item down the list
      if (oldIndex < newIndex){
        newIndex--;
      }
      // get the list are moving
      final demoitem = watchlist!.data["data"]![userId]![index].removeAt(oldIndex);

      // place the list are new position
      watchlist!.data["data"]![userId]![index].insert(newIndex, demoitem);
    });
  }

void deleteWatchListItem(int tabIndex, int itemIndex) {
    setState(() {
      watchlist!.data["data"]![userId]![tabIndex].removeAt(itemIndex);
    });
  }
  void updateTabName(int index, String newName){
    setState(() {
      watchlist!.data["data"]![userId]![0][index] = newName;
      item = nameWatchlist(); // Update the local list
      _tabController = TabController(length: item!.length, vsync: this); // Reset TabController
      _tabController.index = index;
    });
  }

  void addStock(int index,String suggestion,String exchange){
    setState(() {
      watchlist!.data['data']![userId]![index].add("$suggestion+$exchange");
      item = nameWatchlist();
      watchListItem = getItem();
      _tabController = TabController(length: item!.length, vsync: this);
      _tabController.index = index - 1;
      _startFetchingStockData();
    });
  }

  @override
  Widget build(BuildContext context)  {
    final Color oddItemColor = Colors.lime.shade100;
   return  Scaffold(
      appBar: AppBar(
        title: const Text("Watch Stock"),
       bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          // tabs: item.map((title) => _buildTab(title)).toList(),
          tabs: item!.asMap().entries.map((entry){
            final int index = entry.key;
            final String title = entry.value;
            return _buildTab(title,index);
          }).toList()
      ),
      ),
      
        body: NestedScrollView(
        headerSliverBuilder: (BuildContext contex, bool innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true, // Ensures the search bar remains visible
            expandedHeight: kToolbarHeight, // Adjust height if needed
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: "Search & Add",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.mediation),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  
                ),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage(_tabController.index,
                    addStock: (index,suggestion,exchange) => addStock(index, suggestion, exchange))), // Pass title as data
                  );
                  
                             
                },
                
                
              ),
            ),
          ),
        ],
        body: Column(
          children: [ Expanded( // Use Expanded widget for flexible sizing
                      child:TabBarView(
                      controller: _tabController,
                      children: [
                      for (int i=0; i < tabControllerLength; i++ )
                            // SingleChildScrollView(
                              
                               ReorderableListView(
                                
                              
                                children:[ 
                                  
                                  for (String stock in watchlist!.data["data"]![userId]![i+1])
                                      Card(
                                      key: ValueKey<String>(stock),
                                      color: oddItemColor,
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
                                          
                                                  child: Text(stock.split("+")[0]),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                                                  child: Text(
                                                    stock.split("+")[1] ,
                                                    style: const TextStyle(fontSize: 12.0, color: Colors.grey), // Adjust description style
                                                  ),
                                                ),
                                              ],
        
                                                ),
                                            ),
                                          //  ), // Left text takes 2/6 of space
                                          
                                          if (stockData.isNotEmpty)
                                              Expanded(

                                                flex: 4,
                                                child: Row(

                                                  mainAxisAlignment: MainAxisAlignment.end,

                                                  crossAxisAlignment: CrossAxisAlignment.end, // Align texts to right
                                                  children: [
                                                          
                                                          _buildValueRow(stockData[i][stock]?['currentPrice'] ?? ""),
                                                          _buildValueRow(stockData[i][stock]?['amountChange'] ?? ""),
                                                          _buildValueRow(stockData[i][stock]?['percentageChange'] ?? ""),

                                                  ]
                                                ),
                                              ),
                                          
                                        ],
                                      ),
                                    ),

                                      )

                                      // ),

                                ],
                                onReorder: (oldIndex, newIndex) => updateMyWatchList(oldIndex,newIndex,i+1),
                              ),
                                             
                              
          


              
            // else if (watchlist.data["data"]![userId]![i].length == 0)
              
        ],
      ),
         ),
          
        ],
      ),
        ),
   );
  }

  Widget _buildValueRow(String value) {
    return Padding(padding: EdgeInsets.all(8.0),
        child: Text(
          value.split(' ').last, // Extract numerical value
          style: const TextStyle(fontSize: 16.0),
        ),
        );
      
  }



  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onLongPress: () {
        // Navigate to DetailsPage on long press
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TabBarDesging(index,
          onSave: (newName) => updateTabName(index, newName))), // Pass title as data
        );
      },
      child: Tab(
        text: title,
      ),
    );
  } 
}



class SecondPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Second Page Content'));
  }
}

class ThirdPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Third Page Content'));
  }
}

class FourthPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Fourth Page Content'));
  }

}





