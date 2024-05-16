
import 'package:flutter/material.dart';
import "loginandsignup.dart";

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
            
            bottom: 30.0, // Adjust spacing as needed
            width: 120.0,
            height:55.0,
            child:
                  Center(
                      child:ElevatedButton(
                      
                  onPressed: () {
                    // Handle button 1 press
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(color:Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16)
                    ),
                   style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 234, 234, 234), // Set button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
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