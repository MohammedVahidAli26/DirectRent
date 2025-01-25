 import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class PropertyDetailsPage extends StatefulWidget {
  final Map<String, dynamic> propertyData;

  PropertyDetailsPage({required this.propertyData});

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

 void _sharePropertyDetails() async {
  final name = widget.propertyData['name'] ?? 'Property';
  final rent = widget.propertyData['rent'] != null ? '₹${widget.propertyData['rent']}' : 'N/A';
  final location = widget.propertyData['area'] ?? 'N/A';
  final bhk = widget.propertyData['bhk'] ?? 'N/A';
  final List<dynamic> images = widget.propertyData['images'] ?? [];
  final appLink = 'https://directrent.com';

  final shareContent = '''
Property Name: $name
Rent: $rent
Location: $location
BHK: $bhk

Check out this property on our app: $appLink
  ''';

  if (images.isNotEmpty) {
    try {
      final uri = Uri.parse(images[0]);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Save the image temporarily
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/property_image.jpg');
        await file.writeAsBytes(response.bodyBytes);

        // Convert File to XFile
        final xFile = XFile(file.path);

        // Sharing the content with the image
        Share.shareXFiles([xFile], text: shareContent);
        return;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  // Fallback to sharing without an image
  Share.share(shareContent, subject: 'Check out this property!');
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final List<dynamic> images = widget.propertyData['images'] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Details',
          style: GoogleFonts.poppins(
                          color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.w700

                    ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.share_outlined, color: Colors.white),
              onPressed: _sharePropertyDetails,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (images.isNotEmpty)
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.3,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: Lottie.asset('assets/images/load.json'),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                            return Center(
                              
                              child: Column(
                                
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  
                                  Lottie.asset('assets/images/networkerror.json',height: 150,width: 150), 
                                  SizedBox(height: 10),
                                  Text(
                                    "Network Problem",
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },

                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / ${images.length}',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Text(
                  widget.propertyData['name'] ??
                      'Something Went wrong. Check internet connection!',
                   style: GoogleFonts.poppins(
                          color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.w700

                    ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.pink, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.propertyData['address'] ?? 'Network error!',
                         style: GoogleFonts.sora(
                          color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400

                    ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCard('Bed', '${widget.propertyData['bed'] ?? 'N/A'} Bed', Icons.bed, screenWidth),
                    _buildCard('Bath', '${widget.propertyData['bath'] ?? 'N/A'} Bath', Icons.bathtub, screenWidth),
                    _buildCard('BHK', '${widget.propertyData['bhk'] ?? 'N/A'} BHK', Icons.home, screenWidth),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            height: screenHeight * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
  height: MediaQuery.of(context).size.height * 0.02, 
),

                _buildDetailRow(
                  Icons.monetization_on,
                  'Deposit',
                  '₹${widget.propertyData['deposit'] ?? 'N/A'}',
                  Icons.attach_money,
                  'Rent per Month',
                  '₹${widget.propertyData['rent'] ?? 'N/A'}',
                  screenWidth,
                  leftPadding: 16.0,
                ),
SizedBox(
  height: MediaQuery.of(context).size.height * 0.02, 
),                _buildDetailRow(
                  Icons.timelapse,
                  'Deposit Re-payment',
                  '${widget.propertyData['duration'] ?? 'N/A'}',
                  Icons.phone,
                  'Contact',
                  widget.propertyData['contact'] ?? 'N/A',
                  screenWidth,
                  leftPadding: 16.0,
                ),
                SizedBox(
  height: MediaQuery.of(context).size.height * 0.02,
),
                GestureDetector(
                  onTap: () {
                    _launchURL(widget.propertyData['locationUrl'] ?? 'https://www.google.com/maps');
                  },
                  child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 0),
            
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.location_on, color: Colors.pink, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location',
                                style:GoogleFonts.poppins(
                          color: Colors.pink,
                      fontSize: MediaQuery.of(context).size.width * 0.031,
                      fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                widget.propertyData['locationUrl'] ?? 'N/A',
                                 style: GoogleFonts.poppins(
                          color: Colors.blue,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400

                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, double screenWidth) {
    return Container(
      width: screenWidth * 0.28,
      child: Card(
        color: Colors.black,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(icon, size: screenWidth * 0.05, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                   style: GoogleFonts.poppins(
                          color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400

                    ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData leftIcon,
    String leftTitle,
    String leftValue,
    IconData rightIcon,
    String rightTitle,
    String rightValue,
    double screenWidth, {
    double leftPadding = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(leftIcon, color: Colors.pink, size: screenWidth * 0.05),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leftTitle,
                        style: GoogleFonts.poppins(
                          color: Colors.pink,
                      fontSize: MediaQuery.of(context).size.width * 0.031,
                      fontWeight: FontWeight.bold

                    ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        leftValue,
                         style: GoogleFonts.poppins(
                          color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400

                    ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 30),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(rightIcon, color: Colors.pink, size: screenWidth * 0.05),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rightTitle,
                         style: GoogleFonts.poppins(
                          color: Colors.pink,
                      fontSize: MediaQuery.of(context).size.width * 0.031,
                      fontWeight: FontWeight.bold

                    ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        rightValue,
                         style: GoogleFonts.poppins(
                          color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400

                    ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
