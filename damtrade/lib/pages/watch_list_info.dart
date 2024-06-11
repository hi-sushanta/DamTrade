


class WatchlistItem {
  String? uuid;
  Map<String,Map<String,List>> data = {}; 
  Map<String,List<Map<String,dynamic>>> protfollio = {};
  Map<String,double> amountHave = {};
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

  bool ifHaveStock(String uuid, int index, String stockAndExchange){
    for (String stock in data["data"]![uuid]![index]){
      if (stock == stockAndExchange){
        return false;
      }
    }
    return true;
  }
}