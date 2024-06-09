import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../main.dart';
import 'home.dart';

class SecondPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _BusketPage(),
    );
  }
}

class _BusketPage extends StatefulWidget {
  @override
  _BusketPageState createState() => _BusketPageState();
}

class _BusketPageState extends State<_BusketPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final Color oddItemColor = Colors.lime.shade100;
    debugPrint("${watchlist!.protfollio[userId]!.isNotEmpty}");

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Dam Trade",
            style: TextStyle(
                color: Colors.green.shade600, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: watchlist!.protfollio[userId]!.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: ReorderableListView(
                    padding: EdgeInsets.symmetric(vertical: 8.0), // Add padding to avoid large gaps
                    children: [
                      for (List stock in watchlist!.protfollio[userId]!)
                        GestureDetector(
                          key: ValueKey<String>(stock[0]),
                          child: Card(
                            key: ValueKey<String>(stock[0]),
                            color: oddItemColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(stock[0].split("+")[0]),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            stock[0].split("+")[1],
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = watchlist!.protfollio[userId]!.removeAt(oldIndex);
                        watchlist!.protfollio[userId]!.insert(newIndex, item);
                      });
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: Text("You don't have any value?"),
            ),
    );
  }
}
