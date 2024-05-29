
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

void main() async {
  try {
    final htmlData = await fetchHTMLData('https://www.nseindia.com/get-quotes/equity?symbol=HINDALCO');
    parseHTML(htmlData);
  } catch (e) {
    print('Error: $e');
  }
}

Future<String> fetchHTMLData(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load HTML data');
  }
}


void parseHTML(String html) {
  final document = parser.parse(html);
  print(document.outerHtml);
    

}






