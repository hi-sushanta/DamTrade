import 'package:puppeteer/puppeteer.dart';

Future<Map<String,String>> fetchStockData(String symbol) async {
  var browser = await puppeteer.launch(headless: true);
  var page = await browser.newPage();

  // Set user agent and headers to mimic a regular browser
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36');
  await page.setExtraHTTPHeaders({
    'Accept-Language': 'en-US,en;q=0.9',
    'Upgrade-Insecure-Requests': '1',
    'Referer': 'https://www.nseindia.com/',
  });

  // Navigate to the NSE page for the specific stock
  var url = 'https://www.nseindia.com/get-quotes/equity?symbol=$symbol';
  await page.goto(url, wait: Until.networkIdle);

  // Check if the page has loaded the necessary elements
  try {
    await page.waitForSelector('#quoteLtp', timeout: Duration(seconds: 60));

    // Print the page content to inspect the HTML structure

    // Extract the text content of the elements
    String currentPrice = await page.$eval('#quoteLtp', 'element => element.textContent');
    var priceInfo = await page.$eval('#priceInfoStatus', 'element => element.textContent');
    // var amountChange = await page.$eval('#quoteChange', 'element => element.textContent');

    await browser.close();
    var priceChangeData = priceInfo?.trim().split(" ");
    String amountChange = "${priceChangeData[0]}";
    String percentageChanges = "${priceChangeData[1].split("(")[1]}%";
    return {
      "currentPrice": currentPrice,
      "amountChange": amountChange,
      "percentageChange": percentageChanges
    };
    // print('Amount Change: ${amountChange?.trim() ?? 'N/A'}');
  } catch (e) {
    await browser.close();
    throw Exception('Failed to fetch stock data: $e');
  }
}



// void main() async {
//   try {
//     const symbol = 'HINDALCO'; // Example symbol
//     var data = await fetchStockData(symbol);
//     print("$data");
//   } catch (e) {
//     print('Error: $e');
//   }
// }

