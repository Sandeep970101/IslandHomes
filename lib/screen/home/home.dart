import 'dart:convert';

import 'package:ecomm/predict/predict.dart';
import 'package:ecomm/screen/ad_details/ad_details.dart';
import 'package:ecomm/screen/createAdd/createAdd.dart';
import 'package:ecomm/screen/home/components/add_tile.dart';
import 'package:ecomm/screen/profile/profile.dart';
import 'package:ecomm/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.userId, required this.token}) : super(key: key);

  final String userId;
  final String token;

  @override
  _HomeState createState() => _HomeState(userId: userId, token: token);
}

class _HomeState extends State<Home> {
  final String userId;
  final String token;

  _HomeState({required this.userId, required this.token});

  TextEditingController searchController = TextEditingController();

  List<dynamic> approvedAdds = [];
  List<dynamic> fromAdds = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchApprovedAdds();
    fetchFromAdds();
  }

  Future<void> fetchApprovedAdds() async {
    try {
      final response = await http.get(Uri.parse('http://${NetworkUtils.ip}:3002/api/user/get-approved-adds'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          approvedAdds = responseData['data'];
          isLoading = false;
        });
      } else {
        Logger().e('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      Logger().e('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
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

  int currentIndex = 0;

  Future<void> fetchFromAdds() async {
    try {
      String from = searchController.text;
      final response = await http.get(Uri.parse('http://${NetworkUtils.ip}:3002/api/user/get-from-adds/$from'));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          fromAdds = responseData['data'];
          isLoading = false;
        });
      } else {
        Logger().e('Failed to load data: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      Logger().e('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleSearchButton() {
    String searchValue = searchController.text;
    if (searchValue.isNotEmpty) {
      fetchFromAdds();
      setState(() {
        isSearching = true;
      });
    } else {
      fetchApprovedAdds();
      setState(() {
        isSearching = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateAddPage(userId: userId, token: token)));
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(userId: userId, token: token),
            ),
          );
          break;
        case 3:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PredictPage(userId: userId, token: token),
            ),
          );
          break;
      }
    });
  }

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
    imagePaths.shuffle();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Island Homes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      filled: true,
                      // fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _handleSearchButton,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isSearching
              ? fromAdds.isEmpty
                  ? const Center(child: Text('No ads found'))
                  : ListView.builder(
                      itemCount: fromAdds.length,
                      itemBuilder: (context, index) {
                        final add = fromAdds[index];
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
                    )
              : approvedAdds.isEmpty
                  ? const Center(child: Text('No ads found'))
                  : ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      itemCount: approvedAdds.length,
                      physics: const BouncingScrollPhysics(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            label: 'Create Add',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                Icons.batch_prediction,
                color: Colors.black,
              ),
            ),
            label: 'Predict',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
