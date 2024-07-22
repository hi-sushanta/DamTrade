import 'package:flutter/material.dart';
import 'get_optionData.dart';

// void main() {
//   runApp(MyApp());
// }

class OptionChain extends StatelessWidget {
  const OptionChain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      appBar: AppBar(title: Center(
          child:Text("Chain",
          style: TextStyle(color:Colors.green.shade600,fontWeight: FontWeight.bold))),
      backgroundColor: Colors.white),
      body: Center(
        child: Text("Empty Option Chain"),
      )
    );
  }
}
