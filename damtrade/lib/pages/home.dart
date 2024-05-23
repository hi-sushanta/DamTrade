

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import 'dart:ui';
import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import "tab_bar_modify.dart";
import 'watch_list_info.dart';


final userId = FirebaseAuth.instance.currentUser!.uid;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();

  runApp(const Home());
}

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
  late final TabController _tabController;
    final TextEditingController _searchController = TextEditingController();
  var titles = ["watchlist1","watchlist2","watchlist3","watchlist4","watchlist5","watchlist6","watchlist7","watchlist8",'watchlist9',"watchlist10"];
  
  WatchlistItem watchlist = WatchlistItem(userId);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: watchlist.data["data"]![userId]![0].length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  List nameWatchlist(){
    List<String> item = [];
    for (int i=0; i < 10; i++){
      item.add(watchlist.data["data"]![userId]![0][i].toString());
    }
    return item;
  }

  void updateMyWatchList(int oldIndex,int newIndex,index){
    setState(() {
      // an adjustment is needed when moving the item down the list
      if (oldIndex < newIndex){
        newIndex--;
      }
      // get the list are moving
      final item = watchlist.data["data"]![userId]![index].removeAt(oldIndex);

      // place the list are new position
      watchlist.data["data"]![userId]![index].insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    var item = nameWatchlist();

   return Scaffold(
      appBar: AppBar(
        title: const Text("Watch Stock"),
       bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: item.map((title) => _buildTab(title)).toList(),

      ),
      ),
      
        body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true, // Ensures the search bar remains visible
            expandedHeight: kToolbarHeight, // Adjust height if needed
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search Watchlist",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Implement search logic based on user input
                },
                onSubmitted: (value) {
                  
                  // ...
                },
              ),
            ),
          ),
        ],
        body: Column(
          children: [ Expanded( // Use Expanded widget for flexible sizing
                      child:TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                      for (int i=1; i <= 10; i++ )
                            // SingleChildScrollView(
                              ReorderableListView(
                                children:[ 
                                  for (final item in watchlist.data["data"]![userId]![i])
                                      
                                      ListTile(
                                        key: ValueKey(item),
                                        title: Text(item),
                                      ),

                                ],
                                onReorder: (oldIndex, newIndex) => updateMyWatchList(oldIndex,newIndex,i),
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
  Widget _buildTab(String title) {
    return GestureDetector(
      onLongPress: () {
        // Navigate to DetailsPage on long press
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TabBarDesging()), // Pass title as data
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



