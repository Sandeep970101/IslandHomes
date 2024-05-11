import 'dart:convert';

import 'package:ecomm/screen/ad_details/ad_details.dart';
import 'package:ecomm/screen/adminProfile/adminProfile.dart';
import 'package:ecomm/screen/approveAdd/approveAdd.dart';
import 'package:ecomm/screen/home/components/add_tile.dart';
import 'package:ecomm/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key, required this.userId, required this.token}) : super(key: key);

  final String userId;
  final String token;

  @override
  _AdminHomeState createState() => _AdminHomeState(userId: userId, token: token); // Pass userId here
}

class _AdminHomeState extends State<AdminHome> {
  final String userId;
  final String token;

  _AdminHomeState({required this.userId, required this.token}); // No need for another constructor

  List<dynamic> approvedAdds = [];
  bool isLoading = true;
  int _selectedIndex = 0;

// ... rest of your code

  // Index for the selected bottom navigation bar item

  @override
  void initState() {
    super.initState();
    fetchApprovedAdds();
  }

  Future<void> fetchApprovedAdds() async {
    try {
      final response = await http.get(Uri.parse('http://${NetworkUtils.ip}:3002/api/admin/get-all-adds'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          approvedAdds = responseData['data'];
          isLoading = false;
        });
        print(userId);
        print(userId);
        print(userId);
      } else {
        print('Failed to load data: ${response.statusCode}');
        // Handle error cases here
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle error cases here
    }
  }

  List<String> imagePaths = [
    'asset/image/full.jpg',
    'asset/image/home2.jpeg',
    'asset/image/home3.png',
    'asset/image/home4.png',
    'asset/image/home5.jpg',
    // Add more image paths as needed
  ];

  // Function to handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to other screens based on index
      switch (index) {
        case 0:
          // Navigate to the Home screen
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
          break;
        case 1:
          // Navigate to the Profile screen
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ApproveAdd(userId: userId, token: token)));
          break;

        case 2:
          // Navigate to the Profile screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminProfile(userId: userId, token: token),
            ),
          );
          break;
        // Add cases for other screens if needed
      }
    });
  }

  // Function to navigate to the details page of a selected ad
  void _navigateToAdDetails(dynamic ad) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdDetails(
          ad: ad,
          list: approvedAdds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Island Homes'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : approvedAdds.isEmpty
              ? const Center(child: Text('No adds found'))
              : SingleChildScrollView(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    shrinkWrap: true, // Set shrinkWrap to true
                    itemCount: approvedAdds.length,
                    itemBuilder: (context, index) {
                      final add = approvedAdds[index];
                      return AdTile(
                        title: '${add['name'] ?? ''}',
                        description: '${add['description'] ?? ''}',
                        imgUrl: '${add['image'] ?? ''}',
                        location: 'From: ${add['from'] ?? ''}',
                        price: 'Price: ${add['price'] ?? ''}',
                        onTap: () {
                          _navigateToAdDetails(add);
                        },
                        isApproved: add['isApproved'],
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Approve Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // Add more BottomNavigationBarItems for other screens if needed
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
