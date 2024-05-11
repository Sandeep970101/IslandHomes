import 'dart:convert';

import 'package:ecomm/screen/home/home.dart';
import 'package:ecomm/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class PredictPage extends StatefulWidget {
  final String userId;
  final String token;

  const PredictPage({Key? key, required this.userId, required this.token})
      : super(key: key);

  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final TextEditingController bedController = TextEditingController();
  final TextEditingController bathsController = TextEditingController();
  final TextEditingController houseSizeController = TextEditingController();
  final TextEditingController landSizeController = TextEditingController();

  bool _isCreatingAdd = false;

  double predictedPrice = 0.0;

  Future<void> createPredictAdd() async {
    try {
      if (bedController.text.isNotEmpty &&
          bathsController.text.isNotEmpty &&
          houseSizeController.text.isNotEmpty &&
          landSizeController.text.isNotEmpty) {
        Logger().w("asdadsad");

        final response = await http.post(
          Uri.parse(''), // Replace with your API URL and user ID
          headers: {
            // Attach the token to the request
            'Content-Type': 'application/json',
          },
          // body: {
          //   "Land_size": 25,
          //   "House_size": 1000,
          //   "Beds": 5,
          //   "Baths": 3,
          // },
        );

        Logger().e("finished");
        Logger().w(response.body);

        if (response.statusCode == 200) {
          // predict created successfully
          final responseData = jsonDecode(response.body);
          // setState(() {
          predictedPrice = responseData['predicted_price'];
          // });

          showSnackBar(context, 'Predicted Price is $predictedPrice');
        } else {
          // Handle creation failure
          showSnackBar(context, 'Something went wrong !.');
          setState(() {
            _isCreatingAdd = false;
          });
        }
      } else {
        showSnackBar(context, 'Please fill all the fields !.');
      }
    } catch (error) {
      // Handle error

      setState(() {
        _isCreatingAdd = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict Add'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Home(
                        userId: widget.userId,
                        token: widget.token,
                      ))); // Navigate back to the previous screen
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 13),
            TextFormField(
              controller: bedController,
              decoration: const InputDecoration(labelText: 'How Many Beds'),
            ),
            TextFormField(
              controller: bathsController,
              decoration:
                  const InputDecoration(labelText: 'How Many Bathsrooms'),
            ),
            TextFormField(
              controller: houseSizeController,
              decoration:
                  const InputDecoration(labelText: 'House Size (squre feet)'),
            ),
            TextFormField(
              controller: landSizeController,
              decoration: const InputDecoration(labelText: 'Land Size (perch)'),
            ),
            const SizedBox(height: 13),
            ElevatedButton(
              onPressed: () {
                Logger().w("clicked");
                createPredictAdd();
              },
              child: const Text('Predict Add'),
            ),
            const SizedBox(height: 60),
            predictedPrice == 0
                ? Container()
                : Center(
                    child: Text(
                      "The Predicted Price is : $predictedPrice",
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
