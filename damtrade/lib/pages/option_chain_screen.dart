import 'dart:async';

import 'package:flutter/material.dart';
import 'get_optionData.dart';

void main() {
  runApp(OptionChain());
}

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

  Map<String, List<Map<String,dynamic>>> optionData = {};

  List<double> spotPrices = [];//[24834.85, 24950.20, 24730.0];

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_updateSpotPriceIndex);
    _updateOptionData().then((_) => _startFetchingOptionChain());
  }

  void _startFetchingOptionChain() async {
      _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
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
        await getOptionChain.fetchOptionChain("NSE_INDEX|Nifty Finanacial", "2");

        setState(() {
          optionData =  getOptionChain.returnOfData;
          spotPrices = getOptionChain.returnSpotPrice;
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
            Tab(text: 'FINNIFTY'),
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
          _buildOptionChainView(2),
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

    int spotIndex = data.indexWhere((item) => item['Strike'] > spotPrices[tabIndex]);
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
                      "Spot Price: ₹${spotPrices[tabIndex]}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
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

  OptionRow({required this.ce, required this.strike, required this.pe});

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
                debugPrint("CE option Tab: LTP:${ce}, strike: ${strike}")
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
                debugPrint("PE option Tab: Ltp ${pe}, strike: ${strike}")
              },
              ),
            ),
          ),
        ],
      ),
    );
  }

}

