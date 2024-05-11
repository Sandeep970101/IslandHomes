import 'dart:convert';
import 'dart:io';

import 'package:ecomm/controllers/file_upload_controller.dart';
import 'package:ecomm/screen/home/home.dart';
import 'package:ecomm/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class CreateAddPage extends StatefulWidget {
  const CreateAddPage({Key? key, required this.userId, required this.token}) : super(key: key);

  final String userId;
  final String token;

  @override
  _CreateAddPageState createState() => _CreateAddPageState(userId: userId, token: token);
}

class _CreateAddPageState extends State<CreateAddPage> {
  final String userId;
  final String token;
  XFile? _imageFile;
  String? _imageUrl;

  _CreateAddPageState({required this.userId, required this.token});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController fromController = TextEditingController();

  //--file upload controller
  final FileUploadController _fileUploadController = FileUploadController();

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Future<void> pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageUrl = pickedFile.path;
          _imageFile = pickedFile;
        });
      } else {
        showSnackBar(context, 'No image selected.');
      }
    } catch (error) {
      Logger().w('Error picking image: $error');
      showSnackBar(context, 'An error occurred while picking an image.');
    }
  }

  // Future<void> createAdd() async {
  //   try {
  //     final imagePicker = ImagePicker();
  //     final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
  //
  //     if (pickedFile != null) {
  //       final url = Uri.parse('http://${NetworkUtils.ip}:3002/api/user/create-add/$userId');
  //       final request = http.MultipartRequest('POST', url);
  //       Uint8List bytes = await pickedFile.readAsBytes(); // Read file as bytes
  //       Stream<List<int>> stream = Stream.fromIterable([bytes]); // Create a stream from bytes
  //       request.files.add(http.MultipartFile('image', stream, bytes.length, filename: pickedFile.name));
  //
  //
  //       request.fields['name'] = nameController.text;
  //       request.fields['description'] = descriptionController.text;
  //       request.fields['price'] = priceController.text;
  //       request.fields['from'] = fromController.text;
  //
  //       final response = await request.send();
  //
  //       print(response);
  //       print(response.statusCode);
  //       if (response.statusCode == 200) {
  //         final responseData = await response.stream.bytesToString();
  //         final String adId = jsonDecode(responseData)['id'];
  //         print('Success to create ad: ${response.statusCode}');
  //
  //         showSnackBar(context, 'Ad created successfully');
  //       } else {
  //         if (response.statusCode >= 400) {
  //           print('Error creating add');
  //           showSnackBar(context, 'Failed to create ad. Check server logs for details.');
  //         } else {
  //           print('Failed to create ad: ${response.statusCode}');
  //           showSnackBar(context, 'Failed to create ad. Network error.');
  //         }
  //       }
  //     } else {
  //       showSnackBar(context, 'No image selected.');
  //     }
  //   } catch (error) {
  //     print('Error creating ad: $error');
  //     showSnackBar(context, 'An error occurred while creating ad.');
  //   }
  // }

  bool _isCreatingAdd = false;

  Future<void> createAdd() async {
    try {
      if (_imageUrl != null) {
        setState(() {
          _isCreatingAdd = true;
        });
        final String downloadUrl = await _fileUploadController.uploadFile(File(_imageUrl!), "adImages");

        Logger().w(downloadUrl);

        final response = await http.post(
          Uri.parse('http://${NetworkUtils.ip}:3002/api/user/create-add/$userId'), // Replace with your API URL and user ID
          headers: {
            'Authorization': 'Bearer $token', // Attach the token to the request
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'name': nameController.text,
            'description': descriptionController.text,
            'price': priceController.text,
            'from': fromController.text,
            'image': downloadUrl,
          }),
        );

        if (response.statusCode == 200) {
          // Ad created successfully
          final responseData = jsonDecode(response.body);
          final String adId = responseData['id'];
          print('Success to create ad: ${response.statusCode}');

          showSnackBar(context, 'Ad created successfully');

          setState(() {
            _imageFile = null;
            nameController.clear();
            descriptionController.clear();
            priceController.clear();
            fromController.clear();
            _isCreatingAdd = false;
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Home(
                    userId: userId,
                    token: widget.token,
                  )));
          // Handle successful creation, such as showing a success message or navigating to a new page
        } else {
          // Handle creation failure
          print('Failed to create ad: ${response.statusCode}');
          setState(() {
            _isCreatingAdd = false;
          });
        }
      } else {
        showSnackBar(context, 'Select the ad Image.');
      }
    } catch (error) {
      // Handle error
      print('Error creating ad: $error');
      setState(() {
        _isCreatingAdd = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Add'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => Home(
                        userId: userId,
                        token: widget.token,
                      ))); // Navigate back to the previous screen
            });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: _imageFile == null
                    ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo,
                              size: 70,
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Click here to select a photo",
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                      )
                    : Image.file(
                        File(_imageFile!.path),
                        fit: BoxFit.cover,
                        height: 200,
                      ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextFormField(
                controller: fromController,
                decoration: const InputDecoration(labelText: 'From'),
              ),
              const SizedBox(height: 20),
              _isCreatingAdd
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: createAdd,
                      child: const Text('Create Add'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
