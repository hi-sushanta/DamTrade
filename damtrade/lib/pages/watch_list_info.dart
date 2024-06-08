


class WatchlistItem {
  String? uuid;
  Map<String,Map<String,List>> data = {}; 

  WatchlistItem(this.uuid){
    addData(uuid!);
  }
  

 
  void addData(String uuid){
    data["data"] = {uuid:[
     ["watchlist1","watchlist2","watchlist3","watchlist4","watchlist5",
    "watchlist6","watchlist7","watchlist8","watchlist9","watchlist10"],
    ["AAPL+NYSE","IBM+NYSE","TSLA+NYSE"],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    []
    // ["jio","reliance","tata"]
    ]
    };
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