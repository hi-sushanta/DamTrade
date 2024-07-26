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
  const OptionChainScreen({super.key});

  @override
  _OptionChainScreenState createState() => _OptionChainScreenState();
}

class _OptionChainScreenState extends State<OptionChainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Chain",
            style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: buildOptionChainTable(),
    );
  }

  Widget buildOptionChainTable() {
    final List<Map<String, dynamic>> optionChainData = [
      {"callLTP": 247.00, "strike": 24700, "iv": 11.3, "putLTP": 71.45},
      {"callLTP": 210.00, "strike": 24750, "iv": 11.0, "putLTP": 85.70},
      {"callLTP": 177.00, "strike": 24800, "iv": 10.9, "putLTP": 103.00},
      {"callLTP": 148.75, "strike": 24850, "iv": 10.6, "putLTP": 122.30},
      {"callLTP": 122.00, "strike": 24900, "iv": 10.5, "putLTP": 146.80},
      {"callLTP": 99.00, "strike": 24950, "iv": 10.4, "putLTP": 171.20},
      {"callLTP": 77.90, "strike": 25000, "iv": 10.2, "putLTP": 201.75},
      {"callLTP": 59.45, "strike": 25050, "iv": 10.0, "putLTP": 230.65},
      {"callLTP": 44.50, "strike": 25100, "iv": 9.9, "putLTP": 268.90},
      {"callLTP": 32.80, "strike": 25150, "iv": 9.7, "putLTP": 322.45},
      {"callLTP": 24.35, "strike": 25200, "iv": 9.7, "putLTP": 344.00},
      {"callLTP": 17.25, "strike": 25250, "iv": 9.7, "putLTP": 392.35},
      {"callLTP": 12.00, "strike": 25300, "iv": 9.6, "putLTP": 438.70},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          dividerThickness: 4,
          columns: [
            DataColumn(label: Text('Call LTP')),
            DataColumn(label: Text('Strike')),
            DataColumn(label: Text('IV')),
            DataColumn(label: Text('Put LTP')),
          ],
          rows: optionChainData.map((data) {
            return DataRow(
              cells: [
                DataCell(Text(data['callLTP'].toString())),
                DataCell(Text(data['strike'].toString())),
                DataCell(Text(data['iv'].toString())),
                DataCell(Text(data['putLTP'].toString())),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
