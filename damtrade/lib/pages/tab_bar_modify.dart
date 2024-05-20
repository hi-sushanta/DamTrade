
import 'package:flutter/material.dart';

void main() => runApp(const TabBarDesging());

class TabBarDesging extends StatelessWidget {
  const TabBarDesging({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabPage(), // Replace with your actual class name
    );
  }
}

class TabPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TabPage> with TickerProviderStateMixin{
    //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  
  @override
  void initState() {
    super.initState();
  }
  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        ListView.builder(
            itemBuilder: (context, index) => ListTile(
              title: Text('Item ${index + 1} of watchlist 1'),
            ),
            itemCount: 20, // Sample list items
          ),

    );
  
 }
}

