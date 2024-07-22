import 'dart:convert';
import 'package:http/http.dart' as http;

// URLs for fetching data
const String urlOc = "https://www.nseindia.com/option-chain";
const String urlBnf = 'https://www.nseindia.com/api/option-chain-indices?symbol=BANKNIFTY';
const String urlNf = 'https://www.nseindia.com/api/option-chain-indices?symbol=NIFTY';
const String urlFnf = 'https://www.nseindia.com/api/option-chain-indices?symbol=FINNIFTY';
const String urlIndices = "https://www.nseindia.com/api/allIndices";
// Global variables for underlying prices
double nfUl = 0;
// Headers
final Map<String, String> headers = {
  'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36',
  'accept-language': 'en,gu;q=0.9,hi;q=0.8',
  'accept-encoding': 'gzip, deflate, br'
};

Map<String, String> cookies = {};



Future<void> setCookie() async {
  final response = await http.get(Uri.parse(urlOc), headers: headers);
  cookies = response.headers['set-cookie']?.split(';').map((cookie) {
    final parts = cookie.split('=');
    return MapEntry(parts[0].trim(), parts[1].trim());
  }).fold({}, (map, entry) => map?..addAll({entry.key: entry.value})) ?? {};
}

Future<String> getData(String url) async {
  await setCookie();
  final response = await http.get(Uri.parse(url), headers: {...headers, 'Cookie': cookies.entries.map((e) => '${e.key}=${e.value}').join('; ')});
  if (response.statusCode == 401) {
    await setCookie();
    final retryResponse = await http.get(Uri.parse(url), headers: {...headers, 'Cookie': cookies.entries.map((e) => '${e.key}=${e.value}').join('; ')});
    return retryResponse.body;
  }
  return response.statusCode == 200 ? response.body : "";
}

Future<void> setHeader(String indexName) async {
  final responseText = await getData(urlIndices);
  final data = json.decode(responseText);
  for (var index in data['data']) {
    if (index['index'] == indexName) {
      nfUl = index['last'].toDouble();
    } 
  }
}

Future<Map<String, dynamic>> getOptionChain(String url, String indexName, double currentPrice) async {
  final responseText = await getData(url);
  final data = json.decode(responseText);
  final currExpiryDate = data['records']['expiryDates'][0];
  final listOfData = <List<String>>[];

  for (var item in data['records']['data']) {
    if (item['expiryDate'] == currExpiryDate) {
      final strike = item['strikePrice'];
      final ceLtp = item['CE']?['lastPrice'] ?? 'N/A';
      final peLtp = item['PE']?['lastPrice'] ?? 'N/A';

      listOfData.add([
        (strike.toString().padLeft(10)),
        (ceLtp is num ? ceLtp.toStringAsFixed(2).padLeft(15) : ceLtp.toString().padLeft(15)),
        (peLtp is num ? peLtp.toStringAsFixed(2).padLeft(15) : peLtp.toString().padLeft(15))
      ]);
    }
  }

  return {indexName: [listOfData, currentPrice]};
}

void main() async {
  await setHeader('NIFTY 50');

  final niftyData = await getOptionChain(urlNf, "Nifty", nfUl);
  // final bankniftyData = await getOptionChain(urlBnf, "Bank Nifty", bnfUl);
  // final finaceniftyData = await getOptionChain(urlFnf, "Financial Nifty", fnfUl);

  print(niftyData);
  // print(bankniftyData);
  // print(finaceniftyData);
}

