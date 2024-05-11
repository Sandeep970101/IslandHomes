import 'dart:convert';

import 'package:ecomm/screen/SignIn/SignIn.dart';
import 'package:ecomm/screen/ad_details/ad_details.dart';
import 'package:ecomm/screen/home/components/add_tile.dart';
import 'package:ecomm/screen/home/home.dart';
import 'package:ecomm/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.userId, required this.token}) : super(key: key);

  final String userId;
  final String token;

  @override
  _ProfileState createState() => _ProfileState(userId: userId, token: token);
}

class _ProfileState extends State<Profile> {
  final String userId;
  String token;

  _ProfileState({required this.userId, required this.token});

  List<dynamic> adminData = [];
  bool isLoading = true;
  List<dynamic> approvedAdds = [];

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  List<String> imagePaths = [
    'asset/image/full.jpg',
    'asset/image/home2.jpeg',
    'asset/image/home3.png',
    'asset/image/home4.png',
    'asset/image/home5.jpg',
    // Add more image paths as needed
  ];

  @override
  void initState() {
    super.initState();
    AdminDetails();
    fetchApprovedAdds();
  }

  void AdminDetails() async {
    try {
      final response = await http.get(Uri.parse('http://${NetworkUtils.ip}:3002/api/admin/profile/$userId'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          setState(() {
            adminData = [responseData['user']];
            isLoading = false;
          });
        } else {
          print('Failed to load data: ${responseData['message']}');
        }
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> fetchApprovedAdds() async {
    try {
      final response = await http.get(Uri.parse('http://${NetworkUtils.ip}:3002/api/user/get-user-adds/$userId'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          approvedAdds = responseData['data'];
          isLoading = false;
        });
        print(approvedAdds);
        print(approvedAdds);
        print(approvedAdds);
      } else {
        print('Failed to load data: ${response.statusCode}');
        // Handle error cases here
      }
    } catch (error) {
      print('Error fetching data: $error');
      // Handle error cases here
    }
  }

  //
  // Future<void> logout(String token) async {
  //   try {
  //     final response = await http.post(Uri.parse('http://10.0.2.2:3002/api/user/logout'),
  //       headers: {
  //         'Authorization': 'Bearer $token', // Attach the token to the request
  //         'Content-Type': 'application/json',
  //       },); // Replace with your actual API endpoint
  //     token = "";
  //
  //     print(token);
  //     print(token);
  //     print(token);
  //     print(token);
  //
  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       if (responseData['success'] == true) {
  //         print(' successfully');
  //
  //         Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (BuildContext context) => const SignIn(),
  //         ));
  //
  //         showSnackBar(context, 'Logout successfully');
  //
  //
  //         // Indicate successful deletion
  //       } else {
  //         print('Failed : ${responseData['message']}');
  //
  //         // Indicate deletion failure
  //       }
  //     } else {
  //       print('Failed : ${response.statusCode}');
  //       // Indicate API error
  //     }
  //   } catch (error) {
  //     print('Error  : $error');
  //     // Indicate network or other errors
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => Home(userId: widget.userId, token: widget.token),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FutureBuilder<List<dynamic>>(
          future: Future.value(adminData), // Pass the adminData list directly
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (adminData.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final admin = adminData[0];
              // Rest of your UI code using admin data

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('asset/icon/user.png'), // Placeholder image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Email : ${admin['email']}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Role : ${admin['role']}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Implement logout functionality here

                          token = "";

                          showSnackBar(context, 'Logout successfully');
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => const SignIn(),
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 28), // Adjust the font size as needed
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18), // Adjust the font size as needed
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdDetails(
                                ad: add,
                                list: approvedAdds,
                              ),
                            ),
                          );
                        },
                        isApproved: add['isApproved'],
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
