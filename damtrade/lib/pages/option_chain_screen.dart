import 'dart:async';

import 'package:flutter/material.dart';
import 'get_optionData.dart';
import 'stock_buy.dart';
import 'stock_sell.dart';

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

  Map<String,double> spotPrices = {};
  late ScrollController _scrollController;
  bool _isInitialScroll = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _updateOptionData().then((_) => _startFetchingOptionChain());
  }

  void _onTabChanged() {
    if (!_isInitialScroll) {
      _scrollToSpotPrice(_tabController.index);
      
    }
    _isInitialScroll = false;
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
          // setTimer = 15;
        });

        // Scroll to the spot price after updating the option data
      _scrollToSpotPrice(_tabController.index);

      } catch (e) {
        print('Error updating stock data: $e');

      }
    }

  void _updateSpotPriceIndex() {
    setState(() {});
  }

    void _scrollToSpotPrice(int tabIndex) {
    if (!optionData.containsKey(tabIndex.toString())) return;

    final data = optionData[tabIndex.toString()]!;
    final spotIndex = data.indexWhere((item) => item['Strike'] > spotPrices[tabIndex.toString()]);
    if (spotIndex == -1) return;

    // Calculate the exact offset for the spot price
    const itemHeight = 100.0; // Adjust this value based on the actual item height
    final offset = spotIndex * itemHeight;


    // Scroll to the spot price
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        offset,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }


  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _scrollController.dispose();

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
            controller: _scrollController,
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
                  ce_amountChange: item['ce_amountChange'],
                  pe_amountChange: item['pe_amountChange'],
                  ce_percentageChange: item['ce_percentageChange'],
                  pe_percentageChange: item['pe_percentageChange'],
                  defaultQuantity: item['defaultQuantity'],
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
  final String ce_amountChange;
  final String pe_amountChange;
  final String ce_percentageChange;
  final String pe_percentageChange;
  final String defaultQuantity;
  const OptionRow({super.key, required this.ce, required this.strike, 
                  required this.pe,required this.symbolCe, required this.symbolPe,
                  required this.ce_amountChange, required this.pe_amountChange,
                  required this.ce_percentageChange, required this.pe_percentageChange,
                  required this.defaultQuantity
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
                _onOptionTap(context, 0, symbolCe, ce.toString(), ce_amountChange, ce_amountChange,defaultQuantity)
                // debugPrint("CE option Tab: LTP:${ce}, strike: ${strike}, symbol CE: ${symbolCe}")
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
                _onOptionTap(context, 0, symbolPe, pe.toString(), pe_amountChange, ce_percentageChange,defaultQuantity)
                // debugPrint("PE option Tab: Ltp ${pe}, strike: ${strike}, symbol CE: ${symbolCe}")
              },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onOptionTap(BuildContext context,int watchIndex, String stock,String currentPrice,String amountChange, String percentageChange,String defaultQuantity) {
    final stockData = stock.split("+");
    final stockName = stockData[1];
    final exchange = stockData[2];
    final instrumentKey = stockData[0]+"+"+stockData[3];
    final instrumentType = stockData[1].split(" ")[2];
    // debugPrint("$stockName,$exchange,$instrumentKey,$instrumentType");
   
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
          defaultQuantity: defaultQuantity,
          onBuy: () {
            // Implement Buy action
          if(((currentPrice == '0.0'))) {
              ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(content: Text('Selected Options Price Is 0.0 so please try another one.',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),
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
                  defaultQuantity: defaultQuantity,
                ),

            ),
          );

          }
          },
          onSell: () {
            if(((currentPrice == '0.0'))) {
              ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(content: Text('Selected Options Price Is 0.0 so please try another one.',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),),backgroundColor: Color.fromARGB(255, 247, 62, 11),
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
                livePrice: double.parse(currentPrice),
                defaultQuantity: defaultQuantity,),)
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
  final String defaultQuantity;
  final Function onBuy;
  final Function onSell;
  StockDetailSheet({
    required this.stockName,
    required this.exchange,
    required this.currentPrice,
    required this.amountChange,
    required this.percentageChange,
    required this.defaultQuantity,
    required this.onBuy,
    required this.onSell,
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
          
        ],
      ),
    );
  }
}




