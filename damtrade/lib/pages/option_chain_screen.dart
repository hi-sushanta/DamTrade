import 'package:flutter/material.dart';

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

  final Map<String, List<Map<String, dynamic>>> optionData = {
    "0": [
      {"CE": 284.00, "Strike": 24650, "PE": 59.75},
      {"CE": 247.00, "Strike": 24700, "PE": 71.45},
      {"CE": 210.00, "Strike": 24750, "PE": 85.70},
      {"CE": 177.00, "Strike": 24800, "PE": 103.00},
      {"CE": 148.75, "Strike": 24850, "PE": 122.30},
      {"CE": 122.00, "Strike": 24900, "PE": 146.80},
      {"CE": 99.00, "Strike": 24950, "PE": 171.20},
      {"CE": 77.90, "Strike": 25000, "PE": 201.75},
    ],
    "1": [
      {"CE": 284.00, "Strike": 24650, "PE": 59.75},
      {"CE": 247.00, "Strike": 24700, "PE": 71.45},
      {"CE": 210.00, "Strike": 24750, "PE": 85.70},
      {"CE": 177.00, "Strike": 24800, "PE": 103.00},
      {"CE": 148.75, "Strike": 24850, "PE": 122.30},
      {"CE": 122.00, "Strike": 24900, "PE": 146.80},
      {"CE": 99.00, "Strike": 24950, "PE": 171.20},
      {"CE": 77.90, "Strike": 25000, "PE": 201.75},
    ],
    "2": [
      {"CE": 284.00, "Strike": 24650, "PE": 59.75},
      {"CE": 247.00, "Strike": 24700, "PE": 71.45},
      {"CE": 210.00, "Strike": 24750, "PE": 85.70},
      {"CE": 177.00, "Strike": 24800, "PE": 103.00},
      {"CE": 148.75, "Strike": 24850, "PE": 122.30},
      {"CE": 122.00, "Strike": 24900, "PE": 146.80},
      {"CE": 99.00, "Strike": 24950, "PE": 171.20},
      {"CE": 77.90, "Strike": 25000, "PE": 201.75},
    ]
  };

  final List<double> spotPrices = [24834.85, 24950.20, 24730.0];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_updateSpotPriceIndex);
  }

  void _updateSpotPriceIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          child: Row(
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

  const OptionRow({required this.ce, required this.strike, required this.pe});

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
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    ce.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.add, color: Colors.grey),
                ],
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
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}
