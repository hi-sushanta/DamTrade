import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

// Urls for fetching Data (unchanged)

class GetOptionData{

  static const String urlOc = "https://www.nseindia.com/option-chain";
  static const String urlBnf = 'https://www.nseindia.com/api/option-chain-indices?symbol=BANKNIFTY';
  static const String urlNf = 'https://www.nseindia.com/api/option-chain-indices?symbol=NIFTY';
  static const String urlFnf = 'https://www.nseindia.com/api/option-chain-indices?symbol=FINNIFTY';
  static const String urlIndices = "https://www.nseindia.com/api/allIndices";
  double bnf_ul= 0.0;
  double nf_ul = 0.0;
  double fnf_ul= 0.0;

  Map<String,List<Map<String,dynamic>>> returnOfData = {};
  Map<String,double> returnSpotPrice = {};
  
  Future<void>fetchOptionChain(String symbol,String index) async {
      String optionUrl = '';
      String optionSymbol = '';
      if (symbol == "NSE_INDEX|Nifty 50"){
        optionUrl = urlNf;
        optionSymbol = 'OPTIDX+NIFTY';
      } else if (symbol == "NSE_INDEX|Nifty Bank"){
        optionUrl = urlBnf;
        optionSymbol = "OPTIDX+BANKNIFTY";
      }else if(symbol == "NSE_INDEX|Nifty Finanacial"){
        optionUrl = urlFnf;
        optionSymbol = 'OPTIDX+FINNIFTY';
      }
      List<Map<String,dynamic>> listOfItem = [];
      
        var response = await getData(optionUrl);
        var data = jsonDecode(response);
        String currExpiryDate = data['records']['expiryDates'][0];
        int i = 0;
        double spotPrice = 0;
        for (var item in data['records']['data']){
          if (item['expiryDate'] == currExpiryDate){
            int strike = item['strikePrice'];
            Map<String,dynamic> listOfData = {};
            // if (item['CE']['lastPrice'] == null){
            //   print("NUlll: ${item}");
            // }
            double ce_ltp = double.parse(item['CE']['lastPrice'].toString());
            double pe_ltp = double.parse(item['PE']['lastPrice'].toString());
            List formatDate = currExpiryDate.replaceAll("-", " ").split(" ");
            String symbolCe = "${optionSymbol} ${strike} CE ${formatDate[0]} ${formatDate[1]} ${formatDate[2]}";
            String symbolPe = "${optionSymbol} ${strike} PE ${formatDate[0]} ${formatDate[1]} ${formatDate[2]}";
            listOfData['Strike'] = strike;
            listOfData['CE'] = ce_ltp;
            listOfData['PE'] = pe_ltp;
            listOfData['symbolPe'] = symbolPe;
            listOfData['symbolCe'] = symbolCe;
            listOfData['index'] = i;
            spotPrice = double.parse(item['CE']['underlyingValue'].toString());
            listOfItem.add(listOfData);
            i += 1;
          }
        }
        returnSpotPrice[index] = spotPrice;
        returnOfData[index] = listOfItem;
       
    }

    dynamic getData(String urlo) async {
      final url = Uri.parse(urlo);
      final headers = {
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36',
        'accept-language': 'en,gu;q=0.9,hi;q=0.8',
        'accept-encoding': 'gzip, deflate, br',
        'Accept': 'application/json',
      };
      var response = await http.get(url, headers: headers);
      // print(response.statusCode);
      if (response.statusCode == 401){
        response = await http.get(url,headers: headers);
      } 
      if (response.statusCode == 200){
          return response.body;
      }
      return "";
    }
}
// void main(List<String> args) async{
//    GetOptionData getOptionChain = GetOptionData();
//    try{
//       await getOptionChain.fetchOptionChain("NSE_INDEX|Nifty 50","0");
//       print(getOptionChain.returnSpotPrice);
//       await getOptionChain.fetchOptionChain("NSE_INDEX|Nifty Bank", "1");
//       print(getOptionChain.returnSpotPrice);
//       // await getOptionChain.fetchOptionChain("NSE_INDEX|Nifty Finanacial",'2');
//       // print(getOptionChain.returnSpotPrice);

//    } catch(e){
//     print(e);
//    }
//   //  print(getOptionChain.bnf_ul);
//   //  print(getOptionChain.fnf_ul);
//   //  print(getOptionChain.nf_ul);
//   //  print(getOptionChain.returnSpotPrice);
// }