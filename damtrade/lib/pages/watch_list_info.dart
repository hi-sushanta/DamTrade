
import 'package:damtrade/main.dart';
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
  Map<String, ValueNotifier<double>> amountHave = {};
  Map<String, ValueNotifier<List<List>>> amountAddHistory = {};
  Map<String, ValueNotifier<List<StockAlertStore>>> stockAlertStore = {};

  WatchlistItem(this.uuid) {
    addData(uuid!);
    protfollio[uuid!] = [];
    amountHave[uuid!] = ValueNotifier<double>(3000000.0);
    amountAddHistory[uuid!] = ValueNotifier<List<List>>([]);
    stockAlertStore[uuid!] = ValueNotifier<List<StockAlertStore>>([]);

    // Load initial data from Firestore
    _loadDataFromFirestore();
    // Set up real-time listeners
    _setupListeners();
  }

  

  Future<void> _loadDataFromFirestore() async {
    if (uuid != null) {
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
      // Listen to alert changes
      _firestore.collection('users').doc(uuid).collection('alerts').snapshots().listen((snapshot) {
        var alerts = snapshot.docs.map((doc) {
          var data = doc.data();
          return StockAlertStore.fromMap(data);
        }).toList();

        stockAlertStore[uuid!]!.value = alerts;
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

      // // Listen to amountAddHistory changes
      // _firestore.collection('users').doc(uuid).collection('amountAddHistory').snapshots().listen((snapshot) {
      //   var histories = snapshot.docs.map((doc) => doc.data()['history'] as List<dynamic>).toList();
      //   amountAddHistory[uuid!]!.value = histories.map((h) => h.cast<dynamic>()).toList();
      // });

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

  void setAlert(String uuid, String stockName, String exchangeName, double currentPrice, double alertPrice) {
    
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
    Timer.periodic(Duration(seconds: 10), (timer) async {
      for (var alert in stockAlertStore[uuid]!.value) {
        final stockData = await fetchStockData(alert.stockName);
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

  void updateWatchListItem(int newIndex, int index,dynamic moveItem){
        watchlist!.data["data"]![uuid]![index].insert(newIndex, moveItem);
  }

  void removeWatchListItem(int listIndex, int itemIndex){
      watchlist!.data['data']![uuid]![listIndex].removeAt(itemIndex);
  }
  void addProtfolio(String uuid, String stockName, String orderType, int quantity, double avgPrice, double invPrice, double currPrice, double plAmount) {    
    

    if (protfollio[uuid]!.isNotEmpty){
      int index = 0;
      for (var item in protfollio[uuid]!){
        pindex = item['index'] + 1;
      }
    } else{
      pindex = 0;
    }

    var stock = {
      "name": stockName,
      "orderType": orderType,
      "quantity": quantity,
      "averagePrice": avgPrice,
      "investedAmount": invPrice,
      "currentPrice": currPrice,
      "plAmount": plAmount,
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


  void addData(String uuid) {
    data["data"] = {
      uuid: [
        ["watchlist1", "watchlist2", "watchlist3"],
        ["AAPL+NYSE", "IBM+NYSE", "TSLA+NYSE"],
        [],
        [],
      ]
    };
  }

  void addHistory(String uuid, String amount, String date) {
    if (amountAddHistory[uuid]!.value.isNotEmpty){
      for (var item in amountAddHistory[uuid]!.value){
        hindex = item[5] + 1;
      }
    } else{
      hindex = 0;
    }
    var history = [Icons.add, "Add Money", date, amount, Color(0xFF70E5A0),hindex];
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

  bool ifHaveStock(String uuid, int index, String stockAndExchange) {
    for (String stock in data["data"]![uuid]![index]) {
      if (stock == stockAndExchange) {
        return false;
      }
    }
    return true;
  }
}

class StockAlertStore {
  String exchangeName;
  String stockName;
  double currentPrice;
  double alertPrice;
  int aindex;
  StockAlertStore({
    required this.exchangeName,
    required this.stockName,
    required this.currentPrice,
    required this.alertPrice,
    required this.aindex
  });

  Map<String, dynamic> toMap() {
    return {
      'exchangeName': exchangeName,
      'stockName': stockName,
      'currentPrice': currentPrice,
      'alertPrice': alertPrice,
      'aindex':aindex
    };
  }

  static StockAlertStore fromMap(Map<String, dynamic> map) {
    return StockAlertStore(
      exchangeName: map['exchangeName'],
      stockName: map['stockName'],
      currentPrice: map['currentPrice'],
      alertPrice: map['alertPrice'],
      aindex: map['aindex']
    );
  }
}
