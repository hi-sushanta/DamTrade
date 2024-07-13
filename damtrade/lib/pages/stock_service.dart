// import 'package:puppeteer/puppeteer.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'json_service.dart';



class UpstoxService {
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjkyODIyY2RlOWQxOTc2MTZhZjRiY2UiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzIwODc3NjEyLCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MjA5MDgwMDB9.z8WW1o-gzFmAJoL7Vdj64kcLUjCY5Q-9LQb7BElGcN0';
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
            // print('Data: ${data}');
            
            if (categories  == 'NSE_FO'){
              // print("InstrumentKey:$instrumentKey,Symbol:$symbol , Categories: $categories");

              // print("$categories:${data['data'].keys.toList()[0]}: ${data['data']["${data['data'].keys.toList()[0]}"]}");
              // print("Data: ${data['data']}");
              if (data['data']?.isEmpty){
                  return {
                  "currentPrice":'0',
                  "percentageChange":"0%",
                  "amountChange":'0',
                  'defaultQuanity':'0',
                };

              }
              extractData = formatOptionData(data['data']["${data['data'].keys.toList()[0]}"],symbol.split(" ")[0]);
              // print("Extracted Data: $extractData");
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
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjkyODIyY2RlOWQxOTc2MTZhZjRiY2UiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzIwODc3NjEyLCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MjA5MDgwMDB9.z8WW1o-gzFmAJoL7Vdj64kcLUjCY5Q-9LQb7BElGcN0';

  UpstoxNSEService(this.nseJsonFilePath);

  Future<Map<String, List<String>>> fetchStockSuggestions(String query) async {
    Map<String, List<String>> finalData = {};
    try {
      // print("Query :${query}");
      // Read the local JSON file
      // final file = File(nseJsonFilePath);
      // final jsonString = await file.readAsString();
      // final data = json.decode(jsonString);
      final List<dynamic> data = await nseJsonFilePath.loadJsonData();

      // Filter stocks based on the query
      final matchingStocks = (data).where((item) {
        // print("Item: ${item['trading_symbol']}");
        return (item['trading_symbol'] as String).toLowerCase().contains(query.toLowerCase());
      }).toList();
      // print("MatchingStock: ${matchingStocks}");

      // Extract required details
      final suggestions = matchingStocks.map((item) => item['trading_symbol'] as String).toList();
      final fullName = matchingStocks.map((item) => item['name'] as String).toList();
      final exchangeName = matchingStocks.map((item) => item['exchange'] as String).toList();
      final instrumentKey = matchingStocks.map((item) => item['instrument_key'] as String).toList();
      final instrumentType = matchingStocks.map((item) => item['instrument_type'] as String).toList();

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



// class StockService {
//   final String accessToken;
//   final String instrumentKey;
//   final String symbol;

//   StockService({
//     required this.accessToken,
//     required this.instrumentKey,
//     required this.symbol,
//   });

//   void startListening(void Function(Map<String, String>) onData) {
//     final channel = WebSocketChannel.connect(
//       Uri.parse('wss://api.upstox.com/websocket/market-quote/quotes?instrument_key=$instrumentKey'),
//     );

//     channel.sink.add(jsonEncode({
//       'action': 'subscribe',
//       'instrument_key': instrumentKey,
//       'symbol': symbol,
//       'Authorization': 'Bearer $accessToken',
//     }));

//     channel.stream.listen(
//       (message) {
//         var data = jsonDecode(message);
//         if (data['data'] != null && data['data']["NSE_EQ:$symbol"] != null) {
//           Map<String, String> extractData = formatData(data['data']["NSE_EQ:$symbol"]);
//           onData(extractData);
//         }
//       },
//       onDone: () {
//         print('WebSocket closed');
//       },
//       onError: (error) {
//         print('WebSocket error: $error');
//       },
//     );
//   }

//   Map<String, String> formatData(var data) {
//     double open = data['ohlc']!['open'];
//     String close = data['ohlc']!['close'].toString();
//     double netChange = data['net_change'];
//     String percentageChange = ((netChange / open) * 100).toStringAsFixed(2);

//     return {
//       "currentPrice": close,
//       "percentageChange": "$percentageChange%",
//       "amountChange": netChange.toString(),
//     };
//   }
// }

// void main() {
//   final stockService = StockService(
//     accessToken: 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjgyMjkxYjkxMTM1ZTQ4MmNmODVmYWMiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzE5ODA2MjM1LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MTk4NzEyMDB9.GojtFqfDcmcBx6sbQlhDwrwSByLNXxx9r7H6mpcO_fQ',
//     instrumentKey: 'NSE_EQ|INE585B01010',
//     symbol: 'MARUTI',
//   );

//   stockService.startListening((data) {
//     print('Stock data: $data');
//   });
// }

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


// void main() async {
//   String ticker = 'RELIANCE';
//   Map<String, dynamic> stockData = await _fetchStockData(ticker);
//   print(stockData);
// }

// Future<Map<String, String>> fetchStockData(String symbol, String exchange) async {
//   String url = 'https://www.google.com/finance/quote/$symbol:NASDAQ'; //$exchange';
  
//   var response = await http.get(Uri.parse(url));
  
//   if (response.statusCode == 200) {
//     var document = parser.parse(response.body);
    
//     // Fetch current price
//     var priceElement = document.querySelector('.YMlKec.fxKbKc');
//     if (priceElement == null) {
//       throw Exception('Current price element not found');
//     }
//     double price = double.parse(priceElement.text.trim().substring(1).replaceAll(',', ''));
    
//     // Fetch previous price
//     var prevPriceElement = document.querySelector('.P6K39c');
//     if (prevPriceElement == null) {
//       throw Exception('Previous price element not found');
//     }
//     double prevPrice = double.parse(prevPriceElement.text.trim().substring(1).replaceAll(',', ''));
    
//     double amountChange = price - prevPrice;
//     double percentageChange = (amountChange / prevPrice) * 100;
//     Map<String,String> finalData = {
//       "currentPrice": price.toString(),
//       "amountChange": amountChange.toStringAsFixed(2),
//       "percentageChange": "${percentageChange.toStringAsFixed(2)}%",
//     };
//     return finalData;
//   } else {
//     throw Exception('Failed to load stock data');
//   }
// }

// void main() async {
//   const symbol = "AAPL";
//   var data = await TwelveDataService().fetchStockSuggestions('a');
//   // print(data);
// }




