import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> getIntradayStockData(String symbol, String interval) async {
  final apiKey = "UWW5FGYV50XQSJ0K"; // Replace with your Alpha Vantage API key
  final url = 'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=$interval&apikey=$apiKey';

  final response = await http.get(Uri.parse(url));
  print(response.statusCode);
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final timeSeries = data['Time Series ($interval)'];
    print(data);
    if (timeSeries != null && timeSeries.isNotEmpty) {
      final latestTime = timeSeries.keys.first;
      final latestData = timeSeries[latestTime];
      final stockPrice = latestData['1. open'];

      print('Stock Price of $symbol at $latestTime: $stockPrice');
    } else {
      print('Error: No time series data available.');
      print('Response body: ${response.body}');
    }
  } else {
    print('Failed to load stock data. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

void main() {
  getIntradayStockData('RELIANCE', '1min'); // Example to get 1-minute interval data for Reliance Industries Ltd.
}
