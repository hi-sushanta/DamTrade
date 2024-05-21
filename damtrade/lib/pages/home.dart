

import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import "tab_bar_modify.dart";
import 'watch_list_info.dart';
void main() => runApp(const Home());

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
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();


  var titles = ["watchlist1","watchlist2","watchlist3","watchlist4","watchlist5","watchlist6","watchlist7","watchlist8",'watchlist9',"watchlist10"];
  List<WatchlistItem> watchlist = [WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"]),
                 WatchlistItem("watchlist1",["jio","reliance","tata"])];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: watchlist.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  List nameWatchlist(){
    List<String> item = [];
    for (int i=0; i < 10; i++){
      item.add(watchlist[i].name.toString());
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
      final item = watchlist[index].stock.removeAt(oldIndex);

      // place the list are new position
      watchlist[index].stock.insert(newIndex, item);
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
          tabs: item.map((title) => _buildTab(title)).toList(),//watchlist.map((stock) => _buildTab(stock)).toList(),
            // tabs: <Widget>[
            //   Tab(
            //     icon: const Icon(Icons.cloud_outlined),
            //     text: titles[0],
            //   ),
            //   Tab(
            //     icon: const Icon(Icons.beach_access_sharp),
            //     text: titles[1],
            //   ),
            //   Tab(
            //     icon: const Icon(Icons.brightness_5_sharp),
            //     text: titles[2],
            //   ),
            //   Tab(
            //     icon: const Icon(Icons.access_alarm),
            //     text: titles[3],
            //   ),
            //   Tab(
            //     icon: Icon(Icons.access_alarm_rounded),
            //     text: titles[4],
            //   ),
            // ],
      ),
      ),

      body:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search Watchlist",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                debugPrint(value); //Note
                
                // Implement search logic based on user input (value)
              },
            ),
          ),
         Expanded( // Use Expanded widget for flexible sizing
            child:TabBarView(
        controller: _tabController,
        children: <Widget>[
          for (int i=0; i < 10; i++ )
            ReorderableListView(children:[ 
              for (final item in watchlist[i].stock)
              ListTile(
                key: ValueKey(item),
                title: Text(item),
              ),
          ],
          onReorder: (oldIndex, newIndex) => updateMyWatchList(oldIndex,newIndex,i),
          ),
          
        ],
      ),
         ),
        ],
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


