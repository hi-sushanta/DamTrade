


class WatchlistItem {
  String? uuid;
  Map<String,Map<String,List>> data = {}; 
  Map<String,Map<String,List<List>>> protfollio = {};
  WatchlistItem(this.uuid){
    addData(uuid!);
    protfollio[uuid!] = {"stock":[[]]};
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

  void addProtfolio(String uuid, String stockName,List<double> priceInfo){
    protfollio[uuid]!['stock']![0].add([stockName,priceInfo[0],priceInfo[1]]);
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