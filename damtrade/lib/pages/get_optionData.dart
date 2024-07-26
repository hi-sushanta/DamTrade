import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

// Urls for fetching Data (unchanged)
const String urlOc = "https://www.nseindia.com/option-chain";
const String urlBnf = 'https://www.nseindia.com/api/option-chain-indices?symbol=BANKNIFTY';
const String urlNf = 'https://www.nseindia.com/api/option-chain-indices?symbol=NIFTY';
const String urlFnf = 'https://www.nseindia.com/api/option-chain-indices?symbol=FINNIFTY';
const String urlIndices = "https://www.nseindia.com/api/allIndices";

// Headers (unchanged)
const Map<String, String> headers = {
  'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36',
  'accept-language': 'en,gu;q=0.9,hi;q=0.8',
  'accept-encoding': 'gzip, deflate, br',
};

class NSEIndia {
  Map<String, String> cookies = {};
  final http.Client client = http.Client();

  Future<void> setCookie() async {
    final response = await _sendRequest(Uri.parse(urlOc));
    if (response != null && response.statusCode == 200) {
      cookies = _extractCookies(response);
    }
  }

  Future<http.Response?> _sendRequest(Uri url, {int retries = 3}) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        final response = await client.get(url, headers: headers).timeout(Duration(seconds: 10));
        if (response.statusCode == 200) {
          return response;
        }
      } catch (e) {
        print('Attempt ${attempt + 1} failed: $e');
        if (attempt == retries - 1) {
          return null;
        }
        await Future.delayed(Duration(seconds: 2));
      }
    }
    return null;
  }

  Map<String, String> _extractCookies(http.Response response) {
    Map<String, String> cookies = {};
    String? allSetCookie = response.headers['set-cookie'];
    if (allSetCookie != null) {
      var setCookie = allSetCookie.split(',');
      for (var cookie in setCookie) {
        var cookiesList = cookie.split(';');
        for (var c in cookiesList) {
          var kv = c.split('=');
          if (kv.length == 2) {
            cookies[kv[0].trim()] = kv[1].trim();
          }
        }
      }
    }
    return cookies;
  }

  Future<String> getData(String url) async {
    await setCookie();
    final response = await _sendRequestWithCookies(Uri.parse(url));
    if (response != null && response.statusCode == 401) {
      await setCookie();
      final newResponse = await _sendRequestWithCookies(Uri.parse(urlNf));
      if (newResponse != null && newResponse.statusCode == 200) {
        return newResponse.body;
      }
    } else if (response != null && response.statusCode == 200) {
      return response.body;
    }
    return "";
  }

  Future<http.Response?> _sendRequestWithCookies(Uri url) async {
    Map<String, String> headersWithCookies = Map.from(headers);
    if (cookies.isNotEmpty) {
      headersWithCookies['cookie'] = cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    return _sendRequest(url);
  }

  Future<void> setHeader() async {
    final responseText = await getData(urlIndices);
    final data = jsonDecode(responseText);

    for (var index in data['data']) {
      if (index['index'] == "NIFTY 50") {
        nfUl = index['last'];
      } else if (index['index'] == "NIFTY BANK") {
        bnfUl = index['last'];
      } else if (index['index'] == "NIFTY FINANCIAL SERVICES") {
        fnfUl = index['last'];
      }
    }
  }

  Future<Map<String, dynamic>> getOptionChain(String url, String indexName, double currentPrice) async {
    final responseText = await getData(url);
    final data = jsonDecode(responseText);
    final currExpiryDate = data['records']['expiryDates'][0];
    final List<List<String>> listOfData = [];

    for (var item in data['records']['data']) {
      if (item['expiryDate'] == currExpiryDate) {
        final strike = item['strikePrice'];
        var ceLtp = item['CE']?['lastPrice'] ?? "N/A";
        var ceOi = item['CE']?['openInterest'] ?? "N/A";
        var peLtp = item['PE']?['lastPrice'] ?? "N/A";
        var peOi = item['PE']?['openInterest'] ?? "N/A";

        if (ceLtp is double) ceLtp = ceLtp.toStringAsFixed(2);
        if (peLtp is double) peLtp = peLtp.toStringAsFixed(2);

        listOfData.add([strike.toString(), ceLtp, ceOi.toString(), peLtp, peOi.toString()]);
      }
    }

    return {indexName: [listOfData, currentPrice]};
  }
}

double nfUl = 0.0;
double bnfUl = 0.0;
double fnfUl = 0.0;

void main() async {
  final nseIndia = NSEIndia();
  await nseIndia.setHeader();

  final niftyData = await nseIndia.getOptionChain(urlNf, "Nifty", nfUl);
  final bankniftyData = await nseIndia.getOptionChain(urlBnf, "Bank Nifty", bnfUl);
  final finaceniftyData = await nseIndia.getOptionChain(urlFnf, "Financial Nifty", fnfUl);

  print(niftyData);
  print(bankniftyData);
  print(finaceniftyData);
}
