import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:typed_data';
import 'package:damtrade/proto/lib/proto/MarektDataFeed.pb.dart'; // Import the generated protobuf classes

class UpstoxService {
  
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjhmY2RjNzY3ZGUxNzc5NjdhNzU5M2QiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzIwNzAwMzU5LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MjA3MzUyMDB9.OHNp8vYHNxKqHypipy9YWnacpgEMCSL08iXyubg4gIY';
  WebSocketChannel? _channel;
  Map<String, String> extractData = {};
  Completer<void> _dataCompleter = Completer<void>();

  Future<void> fetchStockData(
      String instrumentKey, String symbol, String categories) async {
    final url =
        Uri.parse('https://api.upstox.com/v2/feed/market-data-feed/authorize');
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };

    final response = await http.get(url, headers: headers);
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final authorizedRedirectUri = data['data']['authorizedRedirectUri'];
      await connectWebSocket(
          authorizedRedirectUri, instrumentKey, symbol, categories);
    } else {
      throw Exception('Failed to authorize market data feed');
    }
  }

  Future<void> connectWebSocket(String url, String instrumentKey, String symbol,
      String categories) async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(
      (message) {
        // print('Received message: $message');
        // Assuming the message is in binary format
        Uint8List binaryData = message as Uint8List;
        final decodedData = decodeProtobuf(binaryData);
        // print('Decoded data: $decodedData');
        processData(decodedData,symbol.split("+")[0],categories);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );

    // Send subscription request
    sendSubscriptionRequest(instrumentKey);
  }

  void sendSubscriptionRequest(String instrumentKey) {
    final data = {
      "guid": "someguid",
      "method": "sub",
      "data": {
        "mode": "full",
        "instrumentKeys": [instrumentKey]
      }
    };

    final binaryData = utf8.encode(json.encode(data));
    _channel!.sink.add(binaryData);
  }

  FeedResponse decodeProtobuf(Uint8List buffer) {
    // Decode the protobuf message
    FeedResponse feedResponse = FeedResponse.fromBuffer(buffer);
    return feedResponse;
  }

  void processData(FeedResponse data,String symbol,String categories) {
    // Your logic to process the decoded data
    // print('Processing data: $data');
    // Example of extracting and printing data
    dynamic firstFeed;
    dynamic marketFF;
    dynamic currentPrice;
    dynamic ltpc;
    dynamic previousClose;
    dynamic amountChange;
    dynamic percentageChange;
    dynamic defaultQuantity = '0';

    var feeds = data.feeds;
    if (categories == "NSE_INDEX"){
       firstFeed = feeds.values.first;
       marketFF = firstFeed.ff.indexFF;
       ltpc = marketFF.ltpc;
      currentPrice = ltpc.ltp;
      previousClose = ltpc.cp;
      amountChange = (currentPrice - previousClose);
      percentageChange = (amountChange / previousClose) * 100;
      extractData = {
        "currentPrice": currentPrice.toString(),
        "percentageChange": "${percentageChange.toStringAsFixed(2)}%",
        "amountChange": amountChange.toStringAsFixed(2),
        'defaultQuanity':defaultQuantity,
        };

    }else{
      firstFeed = feeds.values.first;
      // print(feeds.keys.toList()[0]);
      marketFF = firstFeed.ff.marketFF;
      ltpc = marketFF.ltpc;
      currentPrice = ltpc.ltp;
      previousClose = ltpc.cp;
      amountChange = (currentPrice - previousClose);
      percentageChange = (amountChange / previousClose) * 100;
      if (categories == "NSE_FO"){
        if (symbol == "NIFTY"){
          defaultQuantity = '25';
        }
        else if(symbol == "BANKNIFTY"){
          defaultQuantity = '15';
        }
        else{
          // defaultQuantity = data['depth']['buy'][0]['quantity'].toString();
          defaultQuantity = ltpc.ltq.toString();
        }
        extractData = {
        "currentPrice": currentPrice.toString(),
        "percentageChange": "${percentageChange.toStringAsFixed(2)}%",
        "amountChange": amountChange.toStringAsFixed(2),
        'defaultQuanity':defaultQuantity,
        };
      } else{
        extractData = {
        "currentPrice": currentPrice.toString(),
        "percentageChange": "${percentageChange.toStringAsFixed(2)}%",
        "amountChange": amountChange.toStringAsFixed(2)
        };
      }
    }
    
    // print("CurrentPrice: $currentPrice");
    // print("Previous close: $previousClose");
    // print("AmountChange: ${amountChange.toStringAsFixed(2)}");
    // print("PercentageChange: ${percentageChange.toStringAsFixed(2)}");
    
    _dataCompleter.complete();
  }

  Future<void> waitForData() async {
    await _dataCompleter.future;
  }

  void dispose() {
    _channel?.sink.close(status.goingAway);
  }
}

void main() async {
  final upstoxService = UpstoxService();
  String instrumentKey = "BANKNIFTY 49500 CE 16 JUL 24+NSE+NSE_FO|36766+CE";
  // String instrumentKey = "RELIANCE+NSE+NSE_EQ|INE002A01018";
  instrumentKey = "NIFTY 500+NSE+NSE_INDEX|Nifty 500+INDEX";
  await upstoxService.fetchStockData(
      instrumentKey.split("+")[2],
      instrumentKey.split("+")[0],
      instrumentKey.split("+")[2].split("|")[0]);

  await upstoxService.waitForData(); // Wait for data to be processed

  print("StockData: ${upstoxService.extractData}");
}

// class UpstoxService {
//   final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjhlNzhlYjU3MzQyYTUzMDJlNTZiZmQiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzIwNjEzMDk5LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MjA2NDg4MDB9.2Sz2dn3OLhlZzC3ap3c6OaYDWXL8cMka1_shNf8ZhfA';
//   WebSocketChannel? _channel;
//   StreamSubscription? _subscription;
//   Timer? _pingTimer;

//   Future<void> getMarketDataFeedAuthorize() async {
//     final url = Uri.parse('https://api.upstox.com/v2/feed/market-data-feed/authorize');
//     final headers = {
//       'Authorization': 'Bearer $accessToken',
//       'Accept': 'application/json',
//     };

//     final response = await http.get(url, headers: headers);
//     print('Status code: ${response.statusCode}');
//     print('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final authorizedRedirectUri = data['data']['authorizedRedirectUri'];
//       _connectWebSocket(authorizedRedirectUri);
//     } else {
//       throw Exception('Failed to authorize market data feed');
//     }
//   }

//   void _connectWebSocket(String url) {
//     print('Connecting to WebSocket URL: $url');
//     _channel = WebSocketChannel.connect(Uri.parse(url));

//     _subscription = _channel!.stream.listen(
//       (message) {
//         print('Received message: $message');
//         try {
//           final decodedMessage = _decodeProtobuf(message);
//           print('Decoded message: $decodedMessage');
//           final dataDict = jsonDecode(decodedMessage);
//           print('DataDict1: $dataDict');
//           _processData(dataDict);
//         } catch (e) {
//           print('Error processing message: $e');
//         }
//       },
//       onError: (error) {
//         print('WebSocket error: $error');
//       },
//       onDone: () {
//         print('WebSocket connection closed with reason: ${_channel!.closeReason}');
//       },
//     );

//     _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
//       print('Sending ping to keep connection alive');
//       _channel!.sink.add(jsonEncode({'type': 'ping'}));
//     });

//     _subscribeToMarketData();
//   }

//   void _subscribeToMarketData() {
//     final data = {
//       "guid": "someguid",
//       "method": "sub",
//       "data": {
//         "mode": "full",
//         "instrumentKeys": ["NSE_EQ|INE970N01027"]
//       }
//     };
//     print('Subscribing to market data: ${jsonEncode(data)}');
//     _channel!.sink.add(jsonEncode(data));
//   }

//   String _decodeProtobuf(String message) {
//     // Implement the logic to decode the protobuf message here
//     // This is a placeholder implementation
//     return utf8.decode(message.codeUnits);
//   }

//   void _processData(Map<String, dynamic> dataDict) {
//     print("DataDict: $dataDict");
//     if (dataDict.containsKey('feeds')) {
//       final feeds = dataDict['feeds'] as Map<String, dynamic>;
//       print("Feeds: $feeds");
//       final ltpc = feeds.values.first['ff']['marketFF']['ltpc'] as Map<String, dynamic>;

//       final currentPrice = ltpc['ltp'];
//       final previousClose = ltpc['cp'];
//       final amountChange = (currentPrice - previousClose).toDouble();
//       final percentageChange = ((amountChange / previousClose) * 100).toDouble();

//       print("CurrentPrice: $currentPrice");
//       print("PreviousClose: $previousClose");
//       print("AmountChange: $amountChange");
//       print("PercentageChange: $percentageChange%");
//     } else {
//       print('Received data does not contain feeds');
//     }
//   }

//   void dispose() {
//     _subscription?.cancel();
//     _channel?.sink.close(status.normalClosure);
//     _pingTimer?.cancel();
//   }
// }

// void main() async {
//   final upstoxService = UpstoxService();
//   await upstoxService.getMarketDataFeedAuthorize();
// }
