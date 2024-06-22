// import 'package:puppeteer/puppeteer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


const apiKey = '99772cd07c144e08a855af9fe47be083'; // iworkhiwhy@gmail.com
// const apiKey = "433d75198c9b4bdf84253a11b3226409"; //hiwhywork@gmail.com

Future<Map<String, String>> fetchStockData(String symbol) async {
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
    Map<String,List<String>> final_data = {};
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

        final_data["suggestion"] = suggestions;
        final_data["fullName"] = fullName;
        final_data['exchange'] = exchangeName;
        return final_data;
      } else {
        return final_data;
      }
    } else {
      throw Exception('Failed to fetch stock suggestions');
    }
  }
}

// void main() async {
//   const symbol = "AAPL";
//   var data = await TwelveDataService().fetchStockSuggestions('a');
//   // print(data);
// }




