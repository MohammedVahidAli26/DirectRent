import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizapp/admin/%60/permissionhandler.dart';
import 'package:quizapp/client/clientLogin.dart';
import 'package:quizapp/client/details.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final ImagePicker _imagePicker = ImagePicker();
  List<File> selectedImages = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bhkController = TextEditingController();
  final TextEditingController bedController = TextEditingController();
  final TextEditingController bathController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController rentController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController locationUrlController = TextEditingController();

  bool isUploading = false;

  Future<void> selectImages() async {
    try {
      final images = await _imagePicker.pickMultiImage();
      if (images != null) {
        setState(() {
          selectedImages = images.map((img) => File(img.path)).toList();
        });
      } else {
        showSnackbar('No images selected!');
      }
    } catch (e) {
      showSnackbar('Error selecting images: $e');
    }
  }

  bool validateFields() {
    if (selectedImages.isEmpty) {
      showSnackbar('Please select at least one image.');
      return false;
    }
    if (nameController.text.isEmpty ||
        bhkController.text.isEmpty ||
        bedController.text.isEmpty ||
        bathController.text.isEmpty ||
        depositController.text.isEmpty ||
        rentController.text.isEmpty ||
        durationController.text.isEmpty ||
        areaController.text.isEmpty ||
        addressController.text.isEmpty ||
        contactController.text.isEmpty ||
        locationUrlController.text.isEmpty) {
      showSnackbar('Please fill in all fields.');
      return false;
    }
    if (!Uri.tryParse(locationUrlController.text)!.hasAbsolutePath) {
      showSnackbar('Please enter a valid location URL.');
      return false;
    }
    return true;
  }

  Future<void> uploadProperty() async {
    if (!validateFields()) return;

    setState(() {
      isUploading = true;
    });

    String imgurClientId = '459552bb172ce03'; 
    List<String> imageUrls = [];

    try {
      for (var image in selectedImages) {
        bool uploadSuccess = false;
        int retryCount = 0;
        const int maxRetries = 3;

        while (!uploadSuccess && retryCount < maxRetries) {
          try {
            final url = Uri.parse('https://api.imgur.com/3/upload');
            final bytes = await image.readAsBytes();
            final request = http.MultipartRequest('POST', url)
              ..headers['Authorization'] = 'Client-ID $imgurClientId'
              ..fields['type'] = 'base64'
              ..fields['image'] = base64Encode(bytes);

            final response = await request.send().timeout(const Duration(seconds: 30));

            if (response.statusCode == 200) {
              final responseData = jsonDecode(await response.stream.bytesToString());
              imageUrls.add(responseData['data']['link']);
              uploadSuccess = true;
            } else {
              retryCount++;
              if (retryCount >= maxRetries) {
                showSnackbar('Failed to upload image: ${image.path}');
                setState(() {
                  isUploading = false;
                });
                return;
              }
            }
          } on TimeoutException catch (_) {
            retryCount++;
            if (retryCount >= maxRetries) {
              showSnackbar('Failed to upload image: ${image.path}');
              setState(() {
                isUploading = false;
              });
              return;
            }
          } catch (e) {
            showSnackbar('Error uploading image: $e');
            setState(() {
              isUploading = false;
            });
            return;
          }
        }
      }

      // Save property details and image URLs to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance.collection('properties').add({
        'name': nameController.text,
        'bhk': bhkController.text,
        'bed': bedController.text,
        'bath': bathController.text,
        'deposit': depositController.text,
        'rent': rentController.text,
        'duration': durationController.text,
        'area': areaController.text,
        'address': addressController.text,
        'contact': contactController.text,
        'locationUrl': locationUrlController.text,
        'images': imageUrls,
      });

      clearForm();
      showSnackbar('Property uploaded successfully.');

      // Fetch the uploaded document and navigate to PropertyDetailsPage
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        Map<String, dynamic> propertyData = docSnapshot.data() as Map<String, dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropertyDetailsPage(propertyData: propertyData)),
        );
      }

    } catch (e) {
      showSnackbar('Error uploading property: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void clearForm() {
    nameController.clear();
    bhkController.clear();
    bedController.clear();
    bathController.clear();
    depositController.clear();
    rentController.clear();
    durationController.clear();
    areaController.clear();
    addressController.clear();
    contactController.clear();
    locationUrlController.clear();
    selectedImages.clear();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home Page',),titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Admin Page',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); 
              },
            ),
            ListTile(
              leading: const Icon(Icons.panorama_photosphere_outlined),
              title: const Text('Uploaded Properties'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UploadedPropertiesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Log out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  Sampleloginui()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: selectImages,
              child: const Text('Select Images'),
            ),
            const SizedBox(height: 10),
            selectedImages.isNotEmpty
                ? SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.file(selectedImages[index], fit: BoxFit.cover),
                        );
                      },
                    ),
                  )
                : const Text('No images selected.'),
            _buildTextField(nameController, 'Name'),
            _buildTextField(bhkController, 'BHK'),
            _buildTextField(bedController, 'Beds'),
            _buildTextField(bathController, 'Baths'),
            _buildTextField(depositController, 'Deposit'),
            _buildTextField(rentController, 'Rent'),
            _buildTextField(durationController, 'Duration'),
            _buildTextField(areaController, 'Area'),
            _buildTextField(addressController, 'Address'),
            _buildTextField(contactController, 'Contact'),
            _buildTextField(locationUrlController, 'Location URL'),
            const SizedBox(height: 20),
            isUploading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: uploadProperty,
                    child: const Text('Upload Property'),
                  ),
          ],
        ),
      ),
    );
  }
}
