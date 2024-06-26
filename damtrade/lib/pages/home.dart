import 'dart:io';

import 'package:damtrade/pages/stock_sell.dart';
import 'package:damtrade/pages/watch_list_info.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import "tab_bar_modify.dart";
import '../main.dart';
import 'stock_service.dart';
import 'dart:async';
import 'search_bar_desgine.dart';
import  'busket_page.dart';
import 'stock_buy.dart';
import 'fund_page.dart';
import 'stock_alart.dart';
import 'stock_alart_page.dart';
import 'package:permission_handler/permission_handler.dart'; // Ensure this import works
import 'json_service.dart';

final userId = FirebaseAuth.instance.currentUser!.uid;
int oneTime = 1;

// final WatchlistItem watchlist = WatchlistItem(userId);

// void main() async{
  
//   WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();

//   runApp(const Home());
// }



Color _colorChangeForStock(String value) {
    final regExp = RegExp('-');

    if (value.contains(regExp)){
      return Colors.red;
    } 
    if(value == "null"){
      return Colors.black;
    }
    else{
      return Colors.green.shade600;
    }
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
    StockAlertPage(), // Replace with your content widget for third tab
    FundsPage(), // Replace with your content widget for fourth tab
  ];
  
  

  @override
  Widget build(BuildContext context) {
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
  Timer? _alertCheckTimer;

  late TabController _tabController;
  late List? item;
  int index = 0;
  Timer? _timer;


  final TextEditingController _searchController = TextEditingController();
  // var titles = ["watchlist1","watchlist2","watchlist3","watchlist4","watchlist5","watchlist6","watchlist7","watchlist8",'watchlist9',"watchlist10"];
  List<Map<String,Map<String,String>>> stockData = [];
  late Map<String,List<String>> watchListItem;
  final UpstoxService _upstoxService = UpstoxService(JsonService());

    // Define a method to refresh the state
  @override
  void initState() {
    super.initState();
    item = nameWatchlist();
    watchListItem = getItem();
      // debugPrint("Hellow It's done");
    _tabController = TabController(length: watchlist!.data['data']![userId]![0].length, vsync: this);
    _requestNotificationPermissions();
    _updateStockData().then((_) => _startFetchingStockData());
    StockAlertService().initializeNotifications();
    _startCheckingAlerts(); // Start checking alerts

  }

  Future<void> _requestNotificationPermissions() async {
    if (Platform.isAndroid && await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }



  // int get tabControllerLength => watchlist!.data["data"]![userId]![0].length;

  
  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _alertCheckTimer?.cancel();
    super.dispose();
  }
  
  List nameWatchlist(){
    List<String> demoitem = [];
    for (int i=0; i < watchlist!.data['data']![userId]![0].length; i++){
      demoitem.add(watchlist!.data["data"]![userId]![0][i].toString());
    }
    return demoitem;
  }

  Map<String,List<String>> getItem(){
    Map<String,List<String>> stock = {};
    for (int i=0; i<watchlist!.data['data']![userId]![0].length; i++){
      List<String> demoitem  = [];
      for (String it in watchlist!.data['data']![userId]![i+1]){
        demoitem.add(it.toUpperCase());
      }
      stock[watchlist!.data['data']![userId]![0][i]] = demoitem;
    }

    return stock;
  }

   void _startCheckingAlerts() {
    _alertCheckTimer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (mounted) {
        var stockAlerts = watchlist!.stockAlertStore[userId]!.value;
        await StockAlertService().checkForAlerts(stockAlerts);
      } else {
        timer.cancel();
      }
    });
  }

void _startFetchingStockData() async {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (mounted) {
        await _updateStockData();
      } else {
        timer.cancel();
      }
    });
  }
  Future<void> _updateStockData() async {
    List<Map<String,Map<String,String>>> updatedStockData = [];

    try {
      for (var watchName in watchListItem.keys) {
        Map<String,Map<String,String>>stockInfo = {};
        for (var stock in watchListItem[watchName]!) {
          String istock = stock.split("+")[0];
          // String iexchange = stock.split("+")[1];
          // Map<String,String> data = await fetchStockData(stock.split("+")[0],stock.split("+")[1]);
            // final instrumentKey = await _upstoxService.getInstrumentKey(istock);
            debugPrint("Stock $istock");
            var data = await _upstoxService.fetchStockData(stock.split("+")[2],istock);
            // print("$instrumentKey stockSymbol: $istock");
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
      watchlist!.updateWatchListItem(newIndex, index, demoitem);
    });
  }

  void deleteWatchListItem(int tabIndex, int itemIndex) {
      setState(() {
        watchlist!.removeWatchListItem(tabIndex, itemIndex);
      });
    }


  void updateTabName(int index, String newName){
    setState(() {
      watchlist!.updateTabName(index, newName);
      item = nameWatchlist(); // Update the local list
      _tabController = TabController(length: item!.length, vsync: this); // Reset TabController
      _tabController.index = index;
    });
  }

  Future<void> _updateSingleStockData(int watchIndex, String stock) async {
  try {
    // String stockSymbol = stock.split("+")[0];
    // String stockExchange = stock.split("+")[1];
    // debugPrint("Fetching data for $stockSymbol");
    Map<String, String> data = await _upstoxService.fetchStockData(stock.split("+")[2],stock.split("+")[0]);

    setState(() {
      // Find the index for the watchlist
      if (watchIndex != -1) {
        stockData[watchIndex][stock] = data;
      }
    });
  } catch (e) {
    debugPrint('Error updating stock data for $stock: $e');
  }
}

Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Duplicate Stock'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Your selected stock is already have in your list🤭🤭🤭'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return GestureDetector(
        behavior:HitTestBehavior.translucent,
        child:const AlertDialog(
        title: Text('Price Not Loaded'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Please Wait your price is not loaded successfully⌛⌛⌛'),
            ],
          ),
        ),
      ),
      onTap: (){
         Navigator.of(context).pop();

      },

      );
    },
  );
}

void addStock(int index,String suggestion,String exchange) async {
    final instrumentKey = await _upstoxService.getInstrumentKey(suggestion);
    setState(()  {

      if (watchlist!.ifHaveStock(userId, index, "$suggestion+$exchange")){
          watchlist!.addStock(index,suggestion,exchange,instrumentKey!);
          item = nameWatchlist();
          watchListItem = getItem();
          _updateSingleStockData(index - 1, "$suggestion+$exchange+$instrumentKey"); // Fetch data immediately for the new stock
      }
      else{
        _showMyDialog();
      }
      _tabController.index = index - 1;

    });
  }

  



  @override
  Widget build(BuildContext context)  {
    final Color oddItemColor = Colors.lime.shade100;
   return ValueListenableBuilder<bool>(
      valueListenable: watchlist!.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (oneTime == 1){
              item = nameWatchlist();
              watchListItem = getItem();
              // debugPrint("Hellow It's done");
              _tabController = TabController(length: watchlist!.data['data']![userId]![0].length, vsync: this);
              oneTime += 1;
          } 
              // item = nameWatchlist();
              // watchListItem = getItem();
              // _tabController = TabController(length: watchlist!.data['data']![userId]![0].length, vsync: this);
          
          // Replace with your actual watchlist display logic
          return  Scaffold(
      appBar: AppBar(
        title: Center(
          child:Text("Dam Trade",
          style: TextStyle(color:Colors.green.shade600,fontWeight: FontWeight.bold),),
        ),
       bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Container(
            alignment: Alignment.center,
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: Colors.amber,
              tabs: item!.asMap().entries.map((entry){
                final int index = entry.key;
                final String title = entry.value;
                return _buildTab(title,index);
              }).toList(),
            ),
          ),
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
                      for (int i=0; i < watchlist!.data["data"]![userId]![0].length; i++ )
                            // SingleChildScrollView(
                              
                               ReorderableListView(
                                
                  
                                children:[ 
                                
                                  for (String stock in watchlist!.data["data"]![userId]![i+1])
                                  GestureDetector(
                                    key: ValueKey<String>(stock),
                                    onTap: (){
                                      debugPrint("watchlist: $i, stock: $stock");
                                      if (stockData.isNotEmpty){
                                          _onStockTap(i,stock,stockData[i][stock]?["currentPrice"]?? "",
                                          stockData[i][stock]?["amountChange"]??"",
                                          stockData[i][stock]?["percentageChange"]??"");

                                      }else{
                                        // _onStockTap(i,stock,"null","null","null");
                                        _showDialog();
                                      }
                                      
                                    },
                                      child: Card(
                                              key: ValueKey<String>(stock),
                                              color: oddItemColor,
                                          
                                              child: Padding(
                                              
                                              padding: const EdgeInsets.all(8.0), // Adjust padding as needed
                                              child: Row(
                                                children: [
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
                                                                  _buildValueRow(stockData[i][stock]?['amountChange'] ?? "",isAmount: true),
                                                                  _buildValueRow(stockData[i][stock]?['percentageChange'] ?? "",isAmount:true),

                                                          ]
                                                        ),
                                                      ),
                                                  
                                                ],
                                              ),
                                            
                                            ),
                                    
                                      )
                                  ),
                                      
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

      },
   );
  }
  // Widget _buildValueRow(String value) {
  //     return Padding(padding: EdgeInsets.all(8.0),
  //     child: Text(
  //       value.split(' ').last,
  //       style: const TextStyle(fontSize: 16.0)),

  //     );

  // }

    void _onStockTap(int watchIndex, String stock,String currentPrice,String amountChange, String percentageChange) {
    final stockData = stock.split("+");
    final stockName = stockData[0];
    final exchange = stockData[1];
    final instrumentKey = stockData[2];
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StockDetailSheet(
          stockName: stockName,
          exchange: exchange,
          currentPrice: currentPrice,
          amountChange: amountChange,
          percentageChange: percentageChange,
          onBuy: () {
            // Implement Buy action
            Navigator.pop(context); // Close the bottom sheet
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Buy action for $stockName')),
            // );
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  StockBuyPage(
                  stockName: stockName,
                  exchangeName: exchange,
                  instrumentKey: instrumentKey,
                  livePrice: double.parse(currentPrice), // Example, use actual BSE price
                ),

            ),
          );

          },
          onSell: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StockSellPage(stockName: stockName, exchangeName: exchange,instrumentKey: instrumentKey, livePrice: double.parse(currentPrice)))
            );
          },
          onSetAlert: () {
            // Implement Set Alert action
            Navigator.pop(context); // Close the bottom sheet
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockAlert(stockName: stockName,exchangeName: exchange,instrumentKey: instrumentKey, currentPrice:currentPrice),
            ),
          );
        },

        );
      },
    );
  }


  Widget _buildValueRow(String value,{bool isAmount = false}) {
    if (isAmount) {
      Color color = _colorChangeForStock(value);
      return Padding(padding: EdgeInsets.all(8.0),
        child: Text(
          value.split(' ').last, // Extract numerical value
          style:  TextStyle(fontSize: 16.0, color: color)
        ));
    }
    else{
      return Padding(padding: EdgeInsets.all(8.0),
      child: Text(
        value.split(' ').last,
        style: const TextStyle(fontSize: 16.0,color: Colors.black)),

      );
    }
      
  }



  Widget _buildTab(String title, int index) {
    return GestureDetector(
      onLongPress: () {
        // Navigate to DetailsPage on long press
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TabBarDesging(index,
          onSave: (newName) => updateTabName(index, newName),
          deleteWatchListItem:(tabIndex, itemIndex) => deleteWatchListItem(tabIndex,itemIndex))), // Pass title as data
        );
      },
      child: Tab(
        text: title,
      ),
    );
  } 
}




class StockDetailSheet extends StatelessWidget {
  final String stockName;
  final String exchange;
  final String currentPrice;
  final String amountChange;
  final String percentageChange;
  final Function onBuy;
  final Function onSell;
  final Function onSetAlert;
  StockDetailSheet({
    required this.stockName,
    required this.exchange,
    required this.currentPrice,
    required this.amountChange,
    required this.percentageChange,
    required this.onBuy,
    required this.onSell,
    required this.onSetAlert,
  });

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stockName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
          
              child:Text(
              exchange,
              style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
          child:Text(currentPrice,style: TextStyle(fontSize: 16)),),
   Padding(
              padding: EdgeInsets.all(4.0),
          child:Text(amountChange,style: TextStyle(fontSize: 16,color: _colorChangeForStock(amountChange)),),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
          child:Text(percentageChange,style: TextStyle(fontSize: 16,color: _colorChangeForStock(percentageChange)),),
            ),
          ],),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => onBuy(),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 33, 243, 61)),
                child: Text('BUY',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255))),
              ),
              ElevatedButton(
                onPressed: () => onSell(),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 236, 12, 12)),
                child: Text('SELL',style:TextStyle(color:Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              onPressed: () => onSetAlert(),
              icon: Icon(Icons.notifications,color: Colors.amber.shade400,),
              label: Text('Set Alert',style: TextStyle(color:Colors.amber.shade400)),
            ),
          ),
        ],
      ),
    );
  }
}






