import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadedPropertiesPage extends StatefulWidget {
  const UploadedPropertiesPage({Key? key}) : super(key: key);

  @override
  _UploadedPropertiesPageState createState() => _UploadedPropertiesPageState();
}

class _UploadedPropertiesPageState extends State<UploadedPropertiesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isUploading = false; // Track the upload progress

  // Function to delete a property
  Future<void> deleteProperty(String docId) async {
    try {
      setState(() {
        _isUploading = true; // Show loading indicator
      });

      await _firestore.collection('properties').doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Property deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete property: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Uploaded Properties'), titleTextStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.indigo,
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('properties').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No properties uploaded yet.'));
              }

              final properties = snapshot.data!.docs;

              return ListView.builder(
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  final property = properties[index];
                  final data = property.data() as Map<String, dynamic>;
                  final docId = property.id;

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display property name
                          Text(
                            data['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Display property details
                          Text('BHK: ${data['bhk'] ?? 'N/A'}'),
                          Text('Beds: ${data['bed'] ?? 'N/A'}'),
                          Text('Baths: ${data['bath'] ?? 'N/A'}'),
                          Text('Deposit: ₹${data['deposit'] ?? 'N/A'}'),
                          Text('Rent: ₹${data['rent'] ?? 'N/A'}'),
                          Text('Duration: ${data['duration'] ?? 'N/A'}'),
                          Text('Area: ${data['area'] ?? 'N/A'}'),
                          Text('Contact: ${data['contact'] ?? 'N/A'}'),
                          Text('Url: ${data['locationUrl']?? 'N/A'}'),
                          const SizedBox(height: 10),

                          // Display images if available
                          data['images'] != null &&
                                  (data['images'] as List).isNotEmpty
                              ? SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        (data['images'] as List).length,
                                    itemBuilder: (context, imgIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Image.network(
                                          data['images'][imgIndex],
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const Text('No images available.'),
                          const SizedBox(height: 10),

                          // Delete button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => deleteProperty(docId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        if (_isUploading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
