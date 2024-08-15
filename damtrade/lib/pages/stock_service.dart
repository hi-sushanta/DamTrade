// import 'package:puppeteer/puppeteer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'json_service.dart';
import 'package:damtrade/main.dart';

class UpstoxService {
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
            'Authorization': 'Bearer ${watchlist!.accessToken}',
          };
          final response = await http.get(url, headers: headers);
          // print("${response.statusCode}");
          // print("InstrumentKey:$instrumentKey,Symbol:$symbol , Categories: $categories");

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            
            if ((categories  == 'NSE_FO') || (categories == 'BSE_FO')){
              
              if (data['data']?.isEmpty){
                  return {
                  "currentPrice":'0',
                  "percentageChange":"0%",
                  "amountChange":'0',
                  'defaultQuantity':'0',
                };

              }
              extractData = formatOptionData(data['data']["${data['data'].keys.toList()[0]}"],symbol.split(" ")[0]);
            } 
            else if((categories == "NSE_INDEX") || (categories == 'BSE_INDEX')){
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
      'defaultQuantity':defaultQuantity,
    };
  }

 Map<String, String> formatOptionData(var data, String symbol) {
    if (data['ohlc'] == null){
        return {
                  "currentPrice":'0',
                  "percentageChange":"0%",
                  "amountChange":'0',
                  'defaultQuantity':'0',
                };

        }
    double open = data['ohlc']!['open'];
    String close = data['ohlc']!['close'].toString();
    double netChange = data['net_change'];

    String percentageChange = "0";
    if (open != 0.0){
      percentageChange = ((netChange/open)*100).toStringAsFixed(2);
    }
    String defaultQuantity = '0';
    if ((symbol == "NIFTY")||(symbol == "FINNIFTY")||(symbol == "SENSEX50")){
      defaultQuantity = '25';
    }
    else if((symbol == "BANKNIFTY") || (symbol == "BANKEX")){
      defaultQuantity = '15';
    } else if((symbol == "SENSEX") || (symbol == "NIFTYNXT50")){
      defaultQuantity = '10';
    } else if(symbol == "MIDCPNIFTY"){
      defaultQuantity = '50';
    }
    else{
      defaultQuantity = data['depth']['buy'][0]['quantity'].toString();
    }
   if((open == 0.0) && (close == "0.0")){
      close = "0";
      return{
      "currentPrice":close,
      "percentageChange":"$percentageChange%",
      "amountChange":'0',
      'defaultQuantity':defaultQuantity,
    };
    }
    return  {
      "currentPrice":close,
      "percentageChange":"$percentageChange%",
      "amountChange":netChange.toString(),
      'defaultQuantity':defaultQuantity,
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
      'defaultQuantity':'1'
    };
  }

}

    



class UpstoxNSEService {
  final JsonService nseJsonFilePath;

  UpstoxNSEService(this.nseJsonFilePath);

  Future<Map<String, List<String>>> fetchStockSuggestions(String query,int categoryIndex) async {
    Map<String, List<String>> finalData = {};
    List<String> category = ["NSE_EQ","BSE_EQ","NSE_FO","BSE_FO","NSE_INDEX","BSE_INDEX"];
    int extraIndex = 1;
    if (categoryIndex == 1){
      extraIndex = 3;
      categoryIndex = 2;
    } else if(categoryIndex == 2){
      extraIndex = 5;
      categoryIndex = 4;
    }

    try {
      final List<dynamic> data = await nseJsonFilePath.loadJsonData();

      // Filter stocks based on the query
      final matchingStocks = (data).where((item) {
        return (item['trading_symbol'] as String).toLowerCase().contains(query.toLowerCase());
      }).toList();
    final nseEqStocks = matchingStocks.where((item) => ((item['segment'] == category[categoryIndex]) || (item['segment'] == category[extraIndex]))).toList();

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




