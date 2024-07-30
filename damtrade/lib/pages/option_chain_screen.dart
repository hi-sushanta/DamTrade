import 'dart:async';

import 'package:flutter/material.dart';
import 'get_optionData.dart';
import 'stock_buy.dart';
import 'stock_sell.dart';
import 'stock_alart.dart';

class OptionChain extends StatelessWidget {
  const OptionChain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OptionChainScreen(),
    );
  }
}

class OptionChainScreen extends StatefulWidget {
  @override
  _OptionChainScreenState createState() => _OptionChainScreenState();
}

class _OptionChainScreenState extends State<OptionChainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GetOptionData getOptionChain = GetOptionData();
  Timer? _timer;
  int setTimer = 5;
  Map<String, List<Map<String,dynamic>>> optionData = {};

  Map<String,double> spotPrices = {};//[24834.85, 24950.20, 24730.0];

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_updateSpotPriceIndex);
    _updateOptionData().then((_) => _startFetchingOptionChain());
  }

  void _startFetchingOptionChain() async {
      _timer = Timer.periodic(Duration(seconds: setTimer), (timer) async {
        if (mounted) {
            await _updateOptionData();
        } else {
          timer.cancel();
        }
      });
    }

    Future<void> _updateOptionData() async {

      try {
        await getOptionChain.fetchOptionChain("NSE_INDEX|Nifty 50","0");
        await getOptionChain.fetchOptionChain("NSE_INDEX|Nifty Bank", "1");

        setState(() {
          optionData =  getOptionChain.returnOfData;
          spotPrices = getOptionChain.returnSpotPrice;
          setTimer = 15;
        });
      } catch (e) {
        print('Error updating stock data: $e');

      }
    }

  void _updateSpotPriceIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Option Chain",
            style: TextStyle(
              color: Colors.green.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'NIFTY'),
            Tab(text: 'BANKNIFTY'),
          ],
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOptionChainView(0),
          _buildOptionChainView(1),
        ],
      ),
    );
  }

  Widget _buildOptionChainView(int tabIndex) {
    if (!optionData.containsKey(tabIndex.toString())) {
      return Center(child: CircularProgressIndicator());
    }
    final List<Map<String, dynamic>> data = optionData[tabIndex.toString()]!;
    data.sort((a, b) => a['Strike'].compareTo(b['Strike']));

    int spotIndex = data.indexWhere((item) => item['Strike'] > spotPrices[tabIndex.toString()]);
    if (spotIndex == -1) {
      spotIndex = data.length;
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          color: Colors.grey.shade300,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("CE", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Strike", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("PE", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index == spotIndex) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      "Spot Price: ₹${spotPrices[tabIndex.toString()]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 33, 223, 84),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              } else {
                final optionIndex = index > spotIndex ? index - 1 : index;
                final item = data[optionIndex];
                return OptionRow(
                  ce: item['CE'],
                  strike: item['Strike'],
                  pe: item['PE'],
                  symbolCe: item['symbolCe'],
                  symbolPe: item['symbolPe'],
                  baseIndex: item['index'],
                  ce_amountChange: item['ce_amountChange'],
                  pe_amountChange: item['pe_amountChange'],
                  ce_percentageChange: item['ce_percentageChange'],
                  pe_percentageChange: item['pe_percentageChange'],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class OptionRow extends StatelessWidget {
  final double ce;
  final int strike;
  final double pe;
  final String symbolCe;
  final String symbolPe;
  final int baseIndex;
  final String ce_amountChange;
  final String pe_amountChange;
  final String ce_percentageChange;
  final String pe_percentageChange;
  
  const OptionRow({super.key, required this.ce, required this.strike, 
                  required this.pe,required this.symbolCe, required this.symbolPe,
                  required this.baseIndex, required this.ce_amountChange, required this.pe_amountChange,
                  required this.ce_percentageChange, required this.pe_percentageChange
            });
    
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 239, 216),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                  child: Column(
                children: [
                  Text(
                    ce.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.add, color: const Color.fromARGB(255, 158, 158, 158)),
                ],
              ),
              onTap: () => {
                debugPrint("CE option Tab: LTP:${ce}, strike: ${strike}, symbol CE: ${symbolCe}, baseIndex: ${baseIndex}")
              },
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Center(
              child: Text(
                strike.toString(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 227, 227),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                child:Column(
                children: [
                  Text(
                    pe.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.add, color: Colors.grey),
                ],
              ),
              onTap: () => {
                debugPrint("PE option Tab: Ltp ${pe}, strike: ${strike}, symbol CE: ${symbolCe}, base Index: ${baseIndex}")
              },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onStockTap(BuildContext context,int watchIndex, String stock,String currentPrice,String amountChange, String percentageChange) {
    final stockData = stock.split("+");
    final stockName = stockData[0];
    final exchange = stockData[1];
    final instrumentKey = stockData[2];
    final instrumentType = stockData[3];
   
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return StockDetailSheet(
          stockName: stockName,
          exchange: exchange,
          currentPrice: currentPrice,
          amountChange: amountChange,
          percentageChange: percentageChange,
          onBuy: () {
            // Implement Buy action
          if (instrumentKey.split("|")[0] == "NSE_INDEX"){
                ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(content: Text('Index Fund Not to buy or sell',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),
                              duration: const Duration(milliseconds: 500),
                              ));
                Navigator.pop(context);
            } else if((instrumentKey.split("|")[0] == "NSE_FO") & ((currentPrice == '0'))) {
              ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(content: Text('Selected Options Is Expired.',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),
                              duration: const Duration(milliseconds: 500),
                              ));
                Navigator.pop(context);
            }
            else{
            Navigator.pop(context); // Close the bottom sheet
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Buy action for $stockName')),
            // );
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  StockBuyPage(
                  stockName: stockName,
                  exchangeName: exchange,
                  instrumentKey: instrumentKey,
                  instrumentType: instrumentType,
                  livePrice: double.parse(currentPrice), // Example, use actual BSE price
                ),

            ),
          );

          }
          },
          onSell: () {
            if (instrumentKey.split("|")[0] == "NSE_INDEX"){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Index Fund Not to buy or sell',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),
                  duration: const Duration(milliseconds: 500),));
                Navigator.pop(context);
            } 
            else if((instrumentKey.split("|")[0] == "NSE_FO") & ((currentPrice == '0'))) {
              ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(content: Text('Selected Options Is Expired.',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),
                              duration: const Duration(milliseconds: 500),
                              ));
                Navigator.pop(context);
            }
            else{
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StockSellPage(
                stockName: stockName, 
                exchangeName: exchange,
                instrumentKey: instrumentKey,
                instrumentType: instrumentType, 
                livePrice: double.parse(currentPrice)))
            );
          }
          },
          onSetAlert: () {
            if((instrumentKey.split("|")[0] == "NSE_FO") & ((currentPrice == '0'))) {
              ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(content: Text('Selected Options Is Expired.',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),
                              duration: const Duration(milliseconds: 500),
                              ));
                Navigator.pop(context);
            } else {
                  // Implement Set Alert action
                  Navigator.pop(context); // Close the bottom sheet
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockAlert(stockName: stockName,exchangeName: exchange,instrumentKey: instrumentKey, currentPrice:currentPrice),
                  ),
                );
              }
          },

        );
      },
    );
    
  }


}


Color _colorChangeForStock(String value) {
    final regExp = RegExp('-');

    if (value.contains(regExp)){
      return Colors.red;
    } 
    if(value == "null"){
      return Colors.black;
    }
    else{
      return Colors.green.shade600;
    }
}

class StockDetailSheet extends StatelessWidget {
  final String stockName;
  final String exchange;
  final String currentPrice;
  final String amountChange;
  final String percentageChange;
  final Function onBuy;
  final Function onSell;
  final Function onSetAlert;
  StockDetailSheet({
    required this.stockName,
    required this.exchange,
    required this.currentPrice,
    required this.amountChange,
    required this.percentageChange,
    required this.onBuy,
    required this.onSell,
    required this.onSetAlert,
  });

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stockName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
          
              child:Text(
              exchange,
              style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
          child:Text(currentPrice,style: TextStyle(fontSize: 16)),),
   Padding(
              padding: EdgeInsets.all(4.0),
          child:Text(amountChange,style: TextStyle(fontSize: 16,color: _colorChangeForStock(amountChange)),),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
          child:Text(percentageChange,style: TextStyle(fontSize: 16,color: _colorChangeForStock(percentageChange)),),
            ),
          ],),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => onBuy(),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 33, 243, 61)),
                child: Text('BUY',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255))),
              ),
              ElevatedButton(
                onPressed: () => onSell(),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 236, 12, 12)),
                child: Text('SELL',style:TextStyle(color:Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton.icon(
              onPressed: () => onSetAlert(),
              icon: Icon(Icons.notifications,color: Colors.amber.shade400,),
              label: Text('Set Alert',style: TextStyle(color:Colors.amber.shade400)),
            ),
          ),
        ],
      ),
    );
  }
}




