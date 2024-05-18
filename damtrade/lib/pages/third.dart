
import 'package:flutter/material.dart';
import "loginandsignup.dart";
import 'AuthService.dart';

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Option 2: Setting Image height to full (with aspect ratio)
          Image.asset(
            'assets/sushanta.jpeg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity
          ),
          // Container for buttons with positioning
            
            Positioned(
                  child:Container(
                    margin:const EdgeInsets.only(bottom:20.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    widthFactor: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                    // Handle button 1 press
                     Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AuthService().handleAuthState()));

                    },
                  child: const Text(
                    'Next',
                    style: TextStyle(color:Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16)
                    ),

                   style: ElevatedButton.styleFrom(
                    fixedSize: Size(120.0, 55.0),
                backgroundColor: Color.fromARGB(255, 234, 234, 234), // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                ),
                  
                ),
                  ),
                  ),
            )
                
              
                
           // Add spacing between buttons
             
        ],
      ),  
      );
  }
}