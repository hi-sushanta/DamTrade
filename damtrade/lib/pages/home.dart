

import "package:flutter/foundation.dart";
import 'package:flutter/material.dart';
import "package:flutter/widgets.dart";
import "tab_bar_modify.dart";

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


  // var titles = ["watchlist1","watchlist2","watchlist3","watchlist4","watchlist5","watchlist6","watchlist7","watchlist8",'watchlist9',"watchlist10"];
 var watchlist = WatchlistItem();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: watchlist.titles.length, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
        appBar: AppBar(
        title: const Text("Watch Stock"),
       bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: watchlist.titles.map((title) => _buildTab(title)).toList(),
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
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
              ),
             
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
          ),
          ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of ${watchlist.titles[index]}'),
            ),
            itemCount: 10, // Sample list items
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

class WatchlistItem {
  var titles = ["watchlist1","watchlist2","watchlist3","watchlist4","watchlist5","watchlist6","watchlist7","watchlist8",'watchlist9',"watchlist10"];
  var item = [];
  
}
