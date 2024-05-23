


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
    ["jio","tata","reliance","mehandra","Airtle","samsung","nokia","hi","li","why","osum","by","like"],
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
   
}