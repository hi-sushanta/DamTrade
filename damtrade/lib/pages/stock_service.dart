// import 'package:puppeteer/puppeteer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'json_service.dart';



class UpstoxService {
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2Njk3OGY2ZTk5NmZhYzJmNzM4MWVjNmEiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzIxMjA4Njg2LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MjEyNTM2MDB9.q0XBdKQ8ft3tZauYzAMA3C82b-eSDEg5qHimwTvLIgU';
  final JsonService jsonService;

  UpstoxService(this.jsonService);


    Future<String?> getInstrumentKey(String tradingSymbol) async {
    try {
      final List<dynamic> data = await jsonService.loadJsonData();
      for (var item in data) {
        if (item['trading_symbol'] == tradingSymbol) {
          return item['instrument_key'];
        }
      }
      return 'null'; // Return null if no match is found
    } catch (e) {
      print("Error finding instrument key: $e");
      return 'null';
    }
  }


  Future<Map<String, String>> fetchStockData(String instrumentKey,String symbol,String categories) async {
   
          Map<String,String> extractData = {};
          final url = Uri.parse('https://api.upstox.com/v2/market-quote/quotes?instrument_key=$instrumentKey');
          final headers = {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
          };
          final response = await http.get(url, headers: headers);
          // print("${response.statusCode}");
          // print("InstrumentKey:$instrumentKey,Symbol:$symbol , Categories: $categories");

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            
            if (categories  == 'NSE_FO'){
              
              if (data['data']?.isEmpty){
                  return {
                  "currentPrice":'0',
                  "percentageChange":"0%",
                  "amountChange":'0',
                  'defaultQuanity':'0',
                };

              }
              extractData = formatOptionData(data['data']["${data['data'].keys.toList()[0]}"],symbol.split(" ")[0]);
            } 
            else if(categories == "NSE_INDEX"){
              extractData = formatIndexData(data['data']["${data['data'].keys.toList()[0]}"]);
            }
            else{
                  extractData =  formatData(data['data']["$categories:$symbol"]);
            }
            return extractData;
          } else {
            throw Exception('No data available');
          }
    
  }

  Map<String,String> formatIndexData(var data){
    double open = data['ohlc']!['open'];
    String close = data['ohlc']!['close'].toString();
    double netChange = data['net_change'];
    String percentageChange = ((netChange/open)*100).toStringAsFixed(2);
    String defaultQuantity = '0';
    return {
      "currentPrice":close,
      "percentageChange":"$percentageChange%",
      "amountChange":netChange.toString(),
      'defaultQuanity':defaultQuantity,
    };
  }

  Map<String, String> formatOptionData(var data, String symbol) {
    if (data['ohlc'] == null){
        return {
                  "currentPrice":'0',
                  "percentageChange":"0%",
                  "amountChange":'0',
                  'defaultQuanity':'0',
                };

        }
    double open = data['ohlc']!['open'];
    String close = data['ohlc']!['close'].toString();
    double netChange = data['net_change'];
    String percentageChange = ((netChange/open)*100).toStringAsFixed(2);
    String defaultQuantity = '0';
    if (symbol == "NIFTY"){
      defaultQuantity = '25';
    }
    else if(symbol == "BANKNIFTY"){
      defaultQuantity = '15';
    }
    else{
      defaultQuantity = data['depth']['buy'][0]['quantity'].toString();
    }
    return  {
      "currentPrice":close,
      "percentageChange":"$percentageChange%",
      "amountChange":netChange.toString(),
      'defaultQuanity':defaultQuantity,
    };
  }

    

  Map<String, String> formatData(var data) {
    double open = data['ohlc']!['open'];
    String close = data['ohlc']!['close'].toString();
    double netChange = data['net_change'];
    String percentageChange = ((netChange/open)*100).toStringAsFixed(2);

    return  {
      "currentPrice":close,
      "percentageChange":"$percentageChange%",
      "amountChange":netChange.toString(),
    };
  }

}

    



class UpstoxNSEService {
  final JsonService nseJsonFilePath;
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2Njk3OGY2ZTk5NmZhYzJmNzM4MWVjNmEiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzIxMjA4Njg2LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MjEyNTM2MDB9.q0XBdKQ8ft3tZauYzAMA3C82b-eSDEg5qHimwTvLIgU';

  UpstoxNSEService(this.nseJsonFilePath);

  Future<Map<String, List<String>>> fetchStockSuggestions(String query,int categoryIndex) async {
    Map<String, List<String>> finalData = {};
    List<String> category = ["NSE_EQ","NSE_FO","NSE_INDEX"];
    try {
      final List<dynamic> data = await nseJsonFilePath.loadJsonData();

      // Filter stocks based on the query
      final matchingStocks = (data).where((item) {
        return (item['trading_symbol'] as String).toLowerCase().contains(query.toLowerCase());
      }).toList();
    final nseEqStocks = matchingStocks.where((item) => item['segment'] == category[categoryIndex]).toList();

    // Extract required details
    final suggestions = nseEqStocks.map((item) => item['trading_symbol'] as String).toList();
    final fullName = nseEqStocks.map((item) => item['name'] as String).toList();
    final exchangeName = nseEqStocks.map((item) => item['exchange'] as String).toList();
    final instrumentKey = nseEqStocks.map((item) => item['instrument_key'] as String).toList();
    final instrumentType = nseEqStocks.map((item) => item['instrument_type'] as String).toList();

      finalData["suggestion"] = suggestions;
      finalData["fullName"] = fullName;
      finalData['exchange'] = exchangeName;
      finalData['instrumentKey'] = instrumentKey;
      finalData['instrumentType'] = instrumentType;
    } catch (e) {
      throw Exception('Failed to fetch stock suggestions: $e');
    }

    return finalData;
  }
}




// void main() async {
//   String symbol = "RELIANCE";
//   String access_token = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjdjMTJjZTNjOGJhNDE5NWJhMzQ0OWIiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzE5NDA3MzEwLCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MTk0MzkyMDB9.36gF6p5cH2BRtW1Gh1GS0u8JULeQ5QzEL_hzSNincFc';
//   UpstoxService stock_instrument = UpstoxService(JsonService());
//   String instrument_key = stock_instrument.getInstrumentKey(symbol) as String;
//   if (instrument_key != 'null'){
//     var data = await stock_instrument.fetchStockData(instrument_key);
//     print(data);
//   } else{
//     print("please double chack symbol");
//   }
  
// }

