// import 'package:puppeteer/puppeteer.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:damtrade/proto/market_data.pb.dart';

import 'json_service.dart';
// const apiKey = '99772cd07c144e08a855af9fe47be083'; // iworkhiwhy@gmail.com
const apiKey = "433d75198c9b4bdf84253a11b3226409"; //hiwhywork@gmail.com

Future<Map<String, String>> fetchStockData(String symbol,String exchangeName) async {
  // Replace with your Twelve Data API key
  final url = 'https://api.twelvedata.com/time_series?symbol=$symbol&interval=1min&apikey=$apiKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data.containsKey('values')) {
      final timeSeries = data['values'];
      // print(timeSeries);
      final latestData = timeSeries.first;

      final openPrice = latestData['open'];
      final closePrice = latestData['close'];
      
      // Ensure correct data type conversion
      final double open = double.parse(openPrice);
      final double close = double.parse(closePrice);
      
      final amountChange = (close - open).toStringAsFixed(2);
      final percentageChange =
          "${((close - open) / open * 100).toStringAsFixed(2)}%";



      return {
        "currentPrice": double.parse(closePrice).toStringAsFixed(2),
        "amountChange": amountChange,
        "percentageChange": percentageChange,
      };
    } else {
      throw Exception('No data available');
    }
  } else {
    throw Exception('Failed to fetch stock data');
  }
}

class TwelveDataService {

  Future<Map<String,List<String>>> fetchStockSuggestions(String query) async {
    Map<String,List<String>> finalData = {};
    final url = 'https://api.twelvedata.com/symbol_search?symbol=$query&apikey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.containsKey('data')) {
        final suggestions = (data['data'] as List)
            .map((item) => item['symbol'] as String)
            .toList();
        final fullName = (data['data'] as List)
              .map((item) => item['instrument_name'] as String)
              .toList();
        final exchangeName = (data['data'] as List)
              .map((item) => item["exchange"] as String)
              .toList();

        finalData["suggestion"] = suggestions;
        finalData["fullName"] = fullName;
        finalData['exchange'] = exchangeName;
        return finalData;
      } else {
        return finalData;
      }
    } else {
      throw Exception('Failed to fetch stock suggestions');
    }
  }
}



class UpstoxService {
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjgyMjkxYjkxMTM1ZTQ4MmNmODVmYWMiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzE5ODA2MjM1LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MTk4NzEyMDB9.GojtFqfDcmcBx6sbQlhDwrwSByLNXxx9r7H6mpcO_fQ';
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


  Future<Map<String, String>> fetchStockData(String instrumentKey,String symbol) async {
    final url = Uri.parse('https://api.upstox.com/v2/market-quote/quotes?instrument_key=$instrumentKey');
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await http.get(url, headers: headers);
    // print(response.statusCode);
    // print("${response.statusCode}");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      Map<String,String> extractData =  formatData(data['data']["NSE_EQ:$symbol"]);
      return extractData;
    } else {
      throw Exception('No data available');
    }
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


class StreamUpstoxService {
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjgyMjkxYjkxMTM1ZTQ4MmNmODVmYWMiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzE5ODA2MjM1LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MTk4NzEyMDB9.GojtFqfDcmcBx6sbQlhDwrwSByLNXxx9r7H6mpcO_fQ';
  WebSocketChannel? channel;

  Future<void> connectWebSocket() async {
      final initialUrl = 'wss://api.upstox.com/v2/feed/market-data-feed';
      
      channel = IOWebSocketChannel.connect(initialUrl, headers: {
      'Authorization': 'Bearer $accessToken',
      "AcceptHeader": '*/*'
    });
     
      channel?.stream.listen((message) {
      try {
        var data = MarketData.fromBuffer(message);
        print('Received data: ${data.toProto3Json()}');
      } catch (e) {
        print('Error decoding message: $e');
      }
    }, onError: (error) {
      print('WebSocket error: $error');
      reconnect();
    }, onDone: () {
      print('WebSocket connection closed.');
      reconnect();
    });
  }

    void reconnect() {
      print('Reconnecting to WebSocket...');
      Future.delayed(Duration(seconds: 5), () {
        connectWebSocket();
      });
    }

    void sendSubscriptionRequest(String instrument_key) {
      final request = {
        "guid": "unique-guid",
        "method": "sub",
        "data": {
          "mode": "full",
          "instrumentKeys": [instrument_key]
        }
      };

      channel?.sink.add(request);
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




