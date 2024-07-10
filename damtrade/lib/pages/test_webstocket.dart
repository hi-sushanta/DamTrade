import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:typed_data';
import 'package:damtrade/proto/lib/proto/MarektDataFeed.pb.dart'; // Import the generated protobuf classes
import 'dart:io';

class UpstoxService {
  
  final String accessToken = 'eyJ0eXAiOiJKV1QiLCJrZXlfaWQiOiJza192MS4wIiwiYWxnIjoiSFMyNTYifQ.eyJzdWIiOiI3TUJVOTgiLCJqdGkiOiI2NjhlNzhlYjU3MzQyYTUzMDJlNTZiZmQiLCJpc011bHRpQ2xpZW50IjpmYWxzZSwiaWF0IjoxNzIwNjEzMDk5LCJpc3MiOiJ1ZGFwaS1nYXRld2F5LXNlcnZpY2UiLCJleHAiOjE3MjA2NDg4MDB9.2Sz2dn3OLhlZzC3ap3c6OaYDWXL8cMka1_shNf8ZhfA';
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _pingTimer;

  Future<void> getMarketDataFeedAuthorize(String instrumentKey) async {
    final url = Uri.parse('https://api.upstox.com/v2/feed/market-data-feed/authorize');
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
      connectWebSocket(authorizedRedirectUri,instrumentKey);
    } else {
      throw Exception('Failed to authorize market data feed');
    }
  }

  void connectWebSocket(String url,String instrumentKey) {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.stream.listen(
      (message) {
        // print('Received message: $message');
        // Assuming the message is in binary format
        Uint8List binaryData = message as Uint8List;
        final decodedData = decodeProtobuf(binaryData);
        // print('Decoded data: $decodedData');
        processData(decodedData,instrumentKey);
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );

     _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      print('Sending ping to keep connection alive');
      _channel!.sink.add(jsonEncode({'type': 'ping'}));
    });

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

  void processData(FeedResponse data,String instrumentKey) {
    // Your logic to process the decoded data
    // print('Processing data: $data');
    // Example of extracting and printing data
    var feeds = data.feeds;
    if (feeds.isNotEmpty) {
      var firstFeed = feeds.values.first;
      print(feeds.keys.toList()[0]);
      var marketFF = firstFeed.ff.marketFF;
      var ltpc = marketFF.ltpc;
      var currentPrice = ltpc.ltp;
      var previousClose = ltpc.cp;
      var amountChange = (currentPrice - previousClose);
      var percentageChange = (amountChange / previousClose) * 100;

      print("CurrentPrice: $currentPrice");
      print("Previous close: $previousClose");
      print("AmountChange: ${amountChange.toStringAsFixed(2)}");
      print("PercentageChange: ${percentageChange.toStringAsFixed(2)}");
    }
  }

  void dispose() {
    _channel?.sink.close(status.goingAway);
  }
}

void main() async {
  final upstoxService = UpstoxService();
  List<String> instrumentKey = ["NSE_EQ|INE585B01010","NSE_EQ|INE319B01014"];
  int i = 0;
  while (i < 2){
      await upstoxService.getMarketDataFeedAuthorize(instrumentKey[i]);
      i++;
      if (i == 2){
        i = 0;
      }
  }
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
