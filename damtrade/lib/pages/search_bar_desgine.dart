import 'dart:async';
import 'package:flutter/material.dart';
import 'stock_service.dart'; // Ensure you have this file properly set up

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<SearchPage> {
  final TwelveDataService _twelveDataService = TwelveDataService();
  List<String> _suggestions = [];
  List<String> _fullName = [];
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
        final finalData = await _twelveDataService.fetchStockSuggestions(query);
        setState(() {
          _suggestions = finalData["suggestion"] ?? [];
          _fullName = finalData["fullName"] ?? [];
        });
      } else {
        setState(() {
          _suggestions = [];
          _fullName = [];
        });
      }
    });
  }

  void _onSuggestionSelected(String suggestion) {
    Navigator.pop(context, suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search & Stock"),
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
          if (_suggestions.isNotEmpty && _fullName.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
            
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  final fullName = _fullName[index];

                  return ListTile(
                    splashColor: Colors.amber,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.0),

                      ),
                      child: const Center(
                        child: Text(
                          "NSE",
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
                      onPressed: () {
                        // Implement add functionality
                        Navigator.pop(context,suggestion);
                      },
                    ),
                    onTap: () => _onSuggestionSelected(suggestion),

                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}