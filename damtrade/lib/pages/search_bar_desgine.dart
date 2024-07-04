import 'dart:async';
import 'package:damtrade/pages/json_service.dart';
import 'package:flutter/material.dart';
import 'stock_service.dart'; // Ensure you have this file properly set up

class SearchPage extends StatefulWidget {
  final int index;
  final Function(int,String,String,String,String) addStock;

  const SearchPage(this.index,{Key? key, required this.addStock}) : super(key: key);

  @override
  _SearchState createState() => _SearchState(this.index,this.addStock);
}

class _SearchState extends State<SearchPage> {
  final int index;
  final Function(int,String,String,String,String) addStock;
  _SearchState(this.index,this.addStock);
  // final TwelveDataService _twelveDataService = TwelveDataService();
  final UpstoxNSEService _upstoxNSEService = UpstoxNSEService(JsonService());
  List<String> _suggestions = [];
  List<String> _fullName = [];
  List<String> _exchangeName = [];
  List<String> _instrumentKey = [];
  List<String> _instrumentType = [];

  Timer? _timer;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        // final finalData = await _twelveDataService.fetchStockSuggestions(query);
        final finalData = await _upstoxNSEService.fetchStockSuggestions(query);
        // debugPrint("Final Data: ${finalData}");
        setState(() {
          _suggestions = finalData["suggestion"] ?? [];
          _fullName = finalData["fullName"] ?? [];
          _exchangeName = finalData["exchange"] ?? [];
          _instrumentKey = finalData['instrumentKey'] ?? [];
          _instrumentType = finalData['instrumentType'] ?? [];
        });
      } else {
        setState(() {
          _suggestions = [];
          _fullName = [];
          _exchangeName = [];
          _instrumentKey = [];
          _instrumentType = [];
        });
      }
    });
  }

  void _onSuggestionSelected(int index , String suggestion,String exchangeName,String instrumentKey,String instrumentType) {
    this.addStock(index+1,suggestion,exchangeName,instrumentKey,instrumentType);
    // watchlist!.data['data']![userId]![index+1].add("$suggestion+$exchangeName");
    // debugPrint("${watchlist!.data['data']![userId]![index+1]}");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Search Stock", style:TextStyle(color:Colors.green.shade600,fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: "Search & Add",
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mediation),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          if (_suggestions.isNotEmpty && _fullName.isNotEmpty && _exchangeName.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
            
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  final fullName = _fullName[index];
                  final exchangeName = _exchangeName[index];
                  final instrumentKey = _instrumentKey[index];
                  final instrumentType = _instrumentType[index];
                  return ListTile(
                    splashColor: Colors.amber,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.0),

                      ),
                      child: Center(
                        child: Text(
                          exchangeName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      suggestion,
                      style: const TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      fullName,
                      style: const TextStyle(
                        color: Color.fromARGB(221, 139, 138, 138),
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      highlightColor: Colors.amber,
                      onPressed: () {
                        // Implement add functionality
                        _onSuggestionSelected(this.index,suggestion,exchangeName,instrumentKey,instrumentType);
                      },
                    ),
                    onTap: () => _onSuggestionSelected(this.index,suggestion,exchangeName,instrumentKey,instrumentType),

                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
