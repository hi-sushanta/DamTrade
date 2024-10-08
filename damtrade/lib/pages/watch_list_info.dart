
import 'package:damtrade/main.dart';
import 'package:damtrade/pages/json_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'stock_service.dart';


class WatchlistItem {
  String? uuid;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int pindex = 0;
  int aindex = 0;
  int hindex = 0;
  Map<String, Map<String, List>> data = {};
  Map<String, List<Map<String, dynamic>>> protfollio = {};
  Map<String, List<Map<String, dynamic>>> history = {};
  Map<String, ValueNotifier<double>> amountHave = {};
  Map<String, ValueNotifier<List<List>>> amountAddHistory = {};
  Map<String, ValueNotifier<List<StockAlertStore>>> stockAlertStore = {};
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true); // To track loading state
  final UpstoxService _upstoxService = UpstoxService(JsonService());
  String accessToken = "";
  WatchlistItem(this.uuid) {
    // addData(uuid!);
    data['data'] = {uuid!:[[],[],[],[]]};
    protfollio[uuid!] = [];
    history[uuid!] = [];
    amountHave[uuid!] = ValueNotifier<double>(3000000.0);
    amountAddHistory[uuid!] = ValueNotifier<List<List>>([]);
    stockAlertStore[uuid!] = ValueNotifier<List<StockAlertStore>>([]);

    // // Load initial data from Firestore
    // _loadDataFromFirestore();
    // // Set up real-time listeners
    // _setupListeners();
    _initializeData();

  }
  Future<void> _initializeData() async {
      await _loadDataFromFirestore();
      _setupListeners();
      isLoading.value = false; // Mark loading as complete
    }

  
  
  Future<void> _saveDataToFirestore() async {
      if (uuid != null) {
        List<dynamic>? nestedData = data["data"]![uuid];
        if (nestedData != null) {
          var flattenedData = _flattenData(nestedData);
          await _firestore.collection('users').doc(uuid).set({
            'data': flattenedData,
          }, SetOptions(merge: true));
        }
      }
    }

    Future<void> updatePortfolioPLAmount(int index, int pindex, double newCurrentPrice,double newPLAmount) async {
        protfollio[uuid]![index]['plAmount'] = newPLAmount;
        protfollio[uuid]![index]['currentPrice'] = newCurrentPrice;
        await _firestore.collection('users').doc(uuid).collection('portfolio').doc(pindex.toString()).update({
          'plAmount': newPLAmount,
        });
        await _firestore.collection('users').doc(uuid).collection('portfolio').doc(pindex.toString()).update({
          "currentPrice":newCurrentPrice
        });
    }


    List<Map<String, dynamic>> _flattenData(List<dynamic>? nestedData) {
      if (nestedData == null) return [];
      return nestedData.asMap().entries.map((entry) {
        return {
          'index': entry.key,
          'value': entry.value,
        };
      }).toList();
    }


    // Helper method to unflatten data
    List<List<dynamic>> _unflattenData(List<Map<String, dynamic>> flattenedData) {
      List<List<dynamic>> nestedData = List.generate(flattenedData.length, (_) => []);
      for (var entry in flattenedData) {
        nestedData[entry['index']] = List<dynamic>.from(entry['value']);
      }
      return nestedData;
    }

  Future<void> _loadDataFromFirestore() async {
    if (uuid != null) {

       // Load data variable
      var docSnapshot = await _firestore.collection('users').doc(uuid).get();
      if (docSnapshot.exists && docSnapshot.data()!.containsKey('data')) {
        List<Map<String, dynamic>> flattenedData = List<Map<String, dynamic>>.from(docSnapshot.data()!['data']);
        data["data"]![uuid!] = _unflattenData(flattenedData);
      } else{
        addData(uuid!);
      }

      var accessSnapshot = await _firestore.collection('accessToken').doc('damTrade').get();
      accessToken = accessSnapshot.data()!['access_token'];
      // Load alerts
      var alertSnapshot = await _firestore
          .collection('users')
          .doc(uuid)
          .collection('alerts')
          .get();

      var alerts = alertSnapshot.docs.map((doc) {
        var data = doc.data();
        return StockAlertStore.fromMap(data);
      }).toList();

      stockAlertStore[uuid!]!.value = alerts;

      // Load portfolio
      var portfolioSnapshot = await _firestore
          .collection('users')
          .doc(uuid)
          .collection('portfolio')
          .get();

      var portfolios = portfolioSnapshot.docs.map((doc) => doc.data()).toList();

      protfollio[uuid!] = portfolios.map((data) => data as Map<String, dynamic>).toList();

      // Load History 
      var historyOfUserSnapshot = await _firestore
          .collection('users')
          .doc(uuid)
          .collection('history')
          .get();
      var historyOfUsers = historyOfUserSnapshot.docs.map((doc) => doc.data()).toList();
      history[uuid!] = historyOfUsers.map((data) => data as Map<String,dynamic>).toList();

      // Load amountHave
      var amountDoc = await _firestore.collection('users').doc(uuid).get();
      if (amountDoc.exists && amountDoc.data()!.containsKey('amountHave')) {
        amountHave[uuid!]!.value = amountDoc.data()!['amountHave'];
      }

      // Load amountAddHistory
      var historySnapshot = await _firestore
          .collection('users')
          .doc(uuid)
          .collection('amountAddHistory')
          .orderBy('timestamp')
          .get();

      var histories = historySnapshot.docs.map((doc) {
        var data = doc.data();
        return [
          Icons.add,
          "Add Money",
          DateFormat('dd MMMM, yyyy').format((data['timestamp'] as Timestamp).toDate()),
          data['amount'],
          Color(0xFF70E5A0),
          data['hindex'],
        ];
      }).toList();

      amountAddHistory[uuid!]!.value = histories;
    }
  }
  
  void _setupListeners() {
    if (uuid != null) {

      // Listen to data variable changes
      _firestore.collection('users').doc(uuid).snapshots().listen((snapshot) {
        if (snapshot.exists && snapshot.data()!.containsKey('data')) {
          List<Map<String, dynamic>> flattenedData = List<Map<String, dynamic>>.from(snapshot.data()!['data']);
          data["data"]![uuid!] = _unflattenData(flattenedData);
        }
      });
      // Listen to alert changes
      _firestore.collection('users').doc(uuid).collection('alerts').snapshots().listen((snapshot) {
        var alerts = snapshot.docs.map((doc) {
          var data = doc.data();
          return StockAlertStore.fromMap(data);
        }).toList();

        stockAlertStore[uuid!]!.value = alerts;
      });

      // Listen to history changes
      _firestore.collection('users').doc(uuid).collection('history').snapshots().listen((snapshot) {
        var historyOfUsers = snapshot.docs.map((doc) => doc.data()).toList();
        history[uuid!] = historyOfUsers.map((data) => data as Map<String, dynamic>).toList();
      });

      // Listen to portfolio changes
      _firestore.collection('users').doc(uuid).collection('portfolio').snapshots().listen((snapshot) {
        var portfolios = snapshot.docs.map((doc) => doc.data()).toList();
        protfollio[uuid!] = portfolios.map((data) => data as Map<String, dynamic>).toList();
      });

      // Listen to amountHave changes
      _firestore.collection('users').doc(uuid).snapshots().listen((snapshot) {
        if (snapshot.exists && snapshot.data()!.containsKey('amountHave')) {
          amountHave[uuid!]!.value = snapshot.data()!['amountHave'];
        }
      });


      // Listen to amountAddHistory changes
      _firestore.collection('users').doc(uuid).collection('amountAddHistory').snapshots().listen((snapshot) {
      var histories = snapshot.docs.map((doc) {
        var data = doc.data();
        var timestamp = data['timestamp'] as Timestamp?;
        // Use current time if timestamp is null
        var date = timestamp != null 
          ? DateFormat('dd MMMM, yyyy').format(timestamp.toDate()) 
          : DateFormat('dd MMMM, yyyy').format(DateTime.now());

        return [
          Icons.add,
          "Add Money",
          date,
          data['amount'],
          Color(0xFF70E5A0),
          data['hindex']
        ];
      }).toList();

      amountAddHistory[uuid!]!.value = histories;
    });
    }
  }

  Future<void> _saveAmountAddHistoryToFirestore(List newHistory,int index) async {
    if (uuid != null) {
      var historyCollection = _firestore
          .collection('users')
          .doc(uuid)
          .collection('amountAddHistory')
          .doc(index.toString());

      // var docRef = historyCollection.doc(); // Create new document with random ID
      await historyCollection.set({
        'amount': newHistory[3],
        'timestamp': FieldValue.serverTimestamp(),
        "hindex": index,
      });
    }
  }

  
  Future<void> _saveAlertToFirestore(StockAlertStore alert,String index) async {
    if (uuid != null) {
      var docRef = _firestore
          .collection('users')
          .doc(uuid)
          .collection('alerts')
          .doc(index);

      await docRef.set(alert.toMap());
    }
  }

  Future<void> _removeAlertFromFirestore(String index) async {
    if (uuid != null) {
      var docRef = _firestore
          .collection('users')
          .doc(uuid)
          .collection('alerts')
          .doc(index);

      await docRef.delete();
    }
  }

  Future<void> _removeProtfollioFromFirestore(String index) async{
    if (uuid != null){
      var docRef = _firestore
          .collection("users")
          .doc(uuid)
          .collection('portfolio')
          .doc(index);
        
      await docRef.delete();
    }
  }

  void setAlert(String uuid, String stockName, String exchangeName, String instrumentKey, double currentPrice, double alertPrice) {
    
    if (stockAlertStore[uuid]!.value.isNotEmpty){
       for (var alert in stockAlertStore[uuid]!.value){
        aindex = alert.aindex + 1;
       }
    } else{
      aindex = 0;
    }
    StockAlertStore alert = StockAlertStore(
      exchangeName: exchangeName,
      stockName: stockName,
      instrumentKey: instrumentKey,
      currentPrice: currentPrice,
      alertPrice: alertPrice,
      aindex: aindex
    );

    stockAlertStore[uuid]!.value = List.from(stockAlertStore[uuid]!.value)..add(alert);

    // Save to Firestore
    _saveAlertToFirestore(alert,aindex.toString());
  }

  void removeAlartStock(String uuid, int index) {
    var alert = stockAlertStore[uuid]!.value[index];
    _removeAlertFromFirestore(alert.aindex.toString());
    stockAlertStore[uuid]!.value.removeAt(index);
    stockAlertStore[uuid]!.notifyListeners();

    // Remove from Firestore
  }

  void startUpdatingPrices(String uuid) {
    Timer.periodic(Duration(seconds: 3), (timer) async {
      for (var alert in stockAlertStore[uuid]!.value) {
        final stockData = await _upstoxService.fetchStockData(alert.stockName,alert.exchangeName,alert.instrumentKey.split("|")[0]);
        alert.currentPrice = double.parse(stockData["currentPrice"]!);
        // Update Firestore with the new current price
        _saveAlertToFirestore(alert,alert.aindex.toString());
      }
      stockAlertStore[uuid]!.notifyListeners();

    });

  }

  Future<void> _savePortfolioToFirestore(int index) async {
    if (uuid != null) {
      for (var stock in protfollio[uuid]!) {
        var docRef = _firestore
            .collection('users')
            .doc(uuid)
            .collection('portfolio')
            .doc(index.toString());

        await docRef.set(stock);
      }
    }
  }

  Future<void> _saveHistoryOfUsersToFirestore(int index) async{
    if(uuid != null){
      for (var stock in history[uuid]!){
        var docRef = _firestore
            .collection('users')
            .doc(uuid)
            .collection('history')
            .doc(index.toString());
        
        await docRef.set(stock);
      }
    }
  }

  void updateWatchListItem(int newIndex, int index,dynamic moveItem){
        data["data"]![uuid]![index].insert(newIndex, moveItem);
        _saveDataToFirestore();
  }

  void removeWatchListItem(int listIndex, int itemIndex){
      data['data']![uuid]![listIndex].removeAt(itemIndex);
      _saveDataToFirestore();
  }
  void addHistoryOfUsers(String uuid, String stockName, String exchangeName,String instrumentKey,String instrumentType ,String orderType, int quantity, double avgPrice, double invPrice, double currPrice, double plAmount, double strikePrice) {    
    
    int pindex = 0;
    if (history[uuid]!.isNotEmpty){
      for (var item in history[uuid]!){
        if (item['index']> pindex){
           pindex = item['index'];
        }
      }
      pindex += 1;
      
    } else{
      pindex = 0;
    }

    var stock = {
      "name": stockName,
      'exchange_name':exchangeName,
      'instrument_key':instrumentKey,
      'instrument_type':instrumentType,
      "orderType": orderType,
      "quantity": quantity,
      "averagePrice": avgPrice,
      "investedAmount": invPrice,
      "currentPrice": currPrice,
      "plAmount": plAmount,
      "strikePrice":strikePrice,
      'index':pindex,
    };

    history[uuid]!.add(stock);
    // Save to Firestore
    _saveHistoryOfUsersToFirestore(pindex);
  }
  void addProtfolio(String uuid, String stockName, String exchangeName,String instrumentKey,String instrumentType ,String orderType, int quantity, double avgPrice, double invPrice, double currPrice, double plAmount, double strikePrice) {    
    
    int pindex = 0;
    if (protfollio[uuid]!.isNotEmpty){
      for (var item in protfollio[uuid]!){
        if (item['index']> pindex){
           pindex = item['index'];
        }
      }
      pindex += 1;
      
    } else{
      pindex = 0;
    }

    var stock = {
      "name": stockName,
      'exchange_name':exchangeName,
      'instrument_key':instrumentKey,
      'instrument_type':instrumentType,
      "orderType": orderType,
      "quantity": quantity,
      "averagePrice": avgPrice,
      "investedAmount": invPrice,
      "currentPrice": currPrice,
      "plAmount": plAmount,
      "strikePrice":strikePrice,
      'index':pindex,
    };

    protfollio[uuid]!.add(stock);
    // Save to Firestore
    _savePortfolioToFirestore(pindex);
  }

  Future<void> _saveAmountHaveToFirestore() async {
    if (uuid != null) {
      await _firestore.collection('users').doc(uuid).set({
        'amountHave': amountHave[uuid]!.value,
      }, SetOptions(merge: true));
    }
  }


  void addData(String uuid) async {
    data["data"] = {
            uuid: [
              ["watchlist1", "watchlist2", "watchlist3"],
              ["RELIANCE+NSE+NSE_EQ|INE002A01018", "TCS+NSE+NSE_EQ|INE467B01029", "MARUTI+NSE+NSE_EQ|INE585B01010"],
              [],
              [],
            ]
          };
        
          

      
    _saveDataToFirestore();
  }

  void addStock(int index, String suggestion, String exchange, String instrumentKey,String instrumentType){
    data['data']![uuid]![index].add("$suggestion+$exchange+$instrumentKey+$instrumentType");
    _saveDataToFirestore();
  }

  void updateTabName(int index, String newName){
      data["data"]![uuid]![0][index] = newName;
      _saveDataToFirestore();
  }

  void addHistory(String uuid, String amount, String date) {
    if (amountAddHistory[uuid]!.value.isNotEmpty){
      for (var item in amountAddHistory[uuid]!.value){
        hindex = item[5] + 1;
      }
    } else{
      hindex = 0;
    }
    var history = [Icons.add, "Add Money", date, amount, Color.fromARGB(255, 54, 236, 8),hindex];
    amountAddHistory[uuid]!.value = List.from(amountAddHistory[uuid]!.value)..add(history);

    // Save only the new history entry to Firestore
    _saveAmountAddHistoryToFirestore(history,hindex);

  }

  bool ifHaveUuid(String uuid) {
    for (String? key in data['data']!.keys.toList()) {
      if (uuid == key) {
        return true;
      }
    }
    return false;
  }

  void decrasePrice(String uuid, double amount) {
    amountHave[uuid]!.value = amountHave[uuid]!.value - amount;

    // Save to Firestore
    _saveAmountHaveToFirestore();
  }

  void removeProtfollio(String uuid, int index,int stockIndex){
    watchlist!.protfollio[uuid]!.removeAt(index);
    _removeProtfollioFromFirestore((stockIndex).toString());
  }
  void incrasePrice(String uuid, double amount) {
    amountHave[uuid]!.value = amountHave[uuid]!.value + amount;

    // Save to Firestore
    _saveAmountHaveToFirestore();
  }

  void addFund(String uuid, double amount) {
    String liveDate = DateFormat('dd MMMM, yyyy').format(DateTime.now());
    amountHave[uuid]!.value = amountHave[uuid]!.value + amount;
    addHistory(uuid, "$amount", liveDate);

    // Save to Firestore
    _saveAmountHaveToFirestore();
  }

  bool ifHaveStock(String uuid, int index, String stockExchangeInstrument){
    for (String stockAndExchangeInstrument in data["data"]![uuid]![index]) {
      if (stockAndExchangeInstrument == stockExchangeInstrument) {
        return false;
      }
    }
    return true;
  }
}

class StockAlertStore {
  String exchangeName;
  String stockName;
  String instrumentKey;
  double currentPrice;
  double alertPrice;
  int aindex;
  StockAlertStore({
    required this.exchangeName,
    required this.stockName,
    required this.instrumentKey,
    required this.currentPrice,
    required this.alertPrice,
    required this.aindex
  });

  Map<String, dynamic> toMap() {
    return {
      'exchangeName': exchangeName,
      'stockName': stockName,
      "instrumentKey":instrumentKey,
      'currentPrice': currentPrice,
      'alertPrice': alertPrice,
      'aindex':aindex
    };
  }

  static StockAlertStore fromMap(Map<String, dynamic> map) {
    return StockAlertStore(
      exchangeName: map['exchangeName'],
      stockName: map['stockName'],
      instrumentKey: map['instrumentKey'],
      currentPrice: map['currentPrice'],
      alertPrice: map['alertPrice'],
      aindex: map['aindex']
    );
  }
}
