// import 'package:puppeteer/puppeteer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'dart:math';
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




