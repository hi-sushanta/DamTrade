
import 'package:flutter/material.dart';
import 'package:damtrade/main.dart';
import 'dart:core';
import 'package:intl/intl.dart';

class WatchlistItem {
  String? uuid;
  Map<String,Map<String,List>> data = {}; 
  Map<String,List<Map<String,dynamic>>> protfollio = {};
  Map<String,ValueNotifier<double>> amountHave = {};
  Map<String,ValueNotifier<List<List>>> amountAddHistory = {};
  WatchlistItem(this.uuid){
    addData(uuid!);
    protfollio[uuid!] = [];
    amountHave[uuid!] = ValueNotifier<double>(3000000.0);
    amountAddHistory[uuid!] = ValueNotifier<List<List>>([]);
  }
  

 
  void addData(String uuid){
    data["data"] = {uuid:[
     ["watchlist1","watchlist2","watchlist3"],
    ["AAPL+NYSE","IBM+NYSE","TSLA+NYSE"],
    [],
    [],
    ]
    };
  }

  void addHistory(String uuid,String amount,String date){
    var history = [Icons.add, "Add Money", date, amount, Color(0xFF70E5A0)];
    watchlist!.amountAddHistory[uuid]!.value = List.from(amountAddHistory[uuid]!.value)..add(history); // Notify listeners
  }

  void addProtfolio(String uuid, String stockName,String orederType,int quantity,double avgPrice,double invPrice,double currPrice,double plAmount){
    protfollio[uuid]!.add({
      "name":stockName,
      "orderType":orederType,
      "quantity":quantity,
      "averagePrice":avgPrice,
      "investedAmount":invPrice,
      "currentPrice": currPrice,
      // "plPercentage": plPercentage,
      "plAmount": plAmount
    });
  }

  bool ifHaveUuid(String uuid){
    for (String? key in data['data']!.keys.toList()){
        if (uuid == key){
             return true;
        }
      }
    return false;
   
  }

  void decrasePrice(String uuid, double amount){
    watchlist!.amountHave[uuid]!.value = watchlist!.amountHave[uuid]!.value - amount;
  }
  void incrasePrice(String uuid,double amount){
    watchlist!.amountHave[uuid]!.value = watchlist!.amountHave[uuid]!.value + amount;
  }

  void addFund(String uuid, double amount){
    String liveDate = DateFormat('dd MMMM, yyyy').format(DateTime.now());
    watchlist!.amountHave[uuid]!.value = watchlist!.amountHave[uuid]!.value + amount;
    watchlist!.addHistory(uuid,"$amount",liveDate);
  }
  bool ifHaveStock(String uuid, int index, String stockAndExchange){
    for (String stock in data["data"]![uuid]![index]){
      if (stock == stockAndExchange){
        return false;
      }
    }
    return true;
  }
}