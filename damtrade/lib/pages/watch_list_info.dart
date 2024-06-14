


import 'dart:math';
import 'package:damtrade/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:damtrade/main.dart';

class WatchlistItem {
  String? uuid;
  Map<String,Map<String,List>> data = {}; 
  Map<String,List<Map<String,dynamic>>> protfollio = {};
  Map<String,double> amountHave = {};
  Map<String,List<List>> amountAddHistory = {};
  WatchlistItem(this.uuid){
    addData(uuid!);
    protfollio[uuid!] = [
      // {
      //   "name": "AAPL",
      //   "quantity": 7,
      //   "averagePrice": 10.15,
      //   "investedAmount": 71.05,
      //   "currentPrice": 8.90,
      //   // "plPercentage": 1.14,
      //   "plAmount": -8.75,
      // },
    ];
    amountHave[uuid!] = 3000000.0;
    amountAddHistory[uuid!] = [];
  }
  

 
  void addData(String uuid){
    data["data"] = {uuid:[
     ["watchlist1","watchlist2","watchlist3"],
    ["AAPL+NYSE","IBM+NYSE","TSLA+NYSE"],
    [],
    [],
    // ["jio","reliance","tata"]
    ]
    };
  }

  void addHistory(Icons icon , String label, String date, String amount, {String color= "S0xFF70E5A0"}){
    watchlist!.amountAddHistory[userId]!.add([icon,label,date,amount,color]);
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
    watchlist!.amountHave[uuid] = watchlist!.amountHave[uuid]! - amount;
  }
  void incrasePrice(String uuid,double amount){
    watchlist!.amountHave[uuid] = watchlist!.amountHave[uuid]! + amount;
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