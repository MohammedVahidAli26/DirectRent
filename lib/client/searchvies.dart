import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'details.dart';
import 'imageloader.dart';

class Searchview extends StatefulWidget {
  final String initialQuery;

  Searchview({Key? key, required this.initialQuery}) : super(key: key);

  @override
  State<Searchview> createState() => _SearchviewState();
}

class _SearchviewState extends State<Searchview> {
  late String searchQuery;
  double _maxRent = 30000; // Single slider for max rent

  @override
  void initState() {
    super.initState();
    searchQuery = widget.initialQuery;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 15),
            child: Padding(
              padding: const EdgeInsets.only(top: 55),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value.trim().toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 5),
                          hintText: 'Search by Location, BHK, Rent',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.04,
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(

                  "Select Maximum Rent amount",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: _maxRent,
                  min: 1000,
                  max: 30000,
                  divisions: 100,
                  label: '₹${_maxRent.toInt()}',
                  onChanged: (double value) {
                    setState(() {
                      _maxRent = value.roundToDouble();
                    });
                  },
                ),
                
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('properties').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading data'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No properties found'));
                }

                // Filter based on the selected max rent
               var filteredDocs = snapshot.data!.docs.where((doc) {
  var data = doc.data() as Map<String, dynamic>;

  // Fetch and parse the rent value
  double? rentValue = (data['rent'] is num) 
      ? (data['rent'] as num).toDouble() 
      : double.tryParse(data['rent']?.toString() ?? '');

  // Ensure rentValue is valid and falls within the selected range
  if (rentValue == null || rentValue > _maxRent) return false;

  // Check searchQuery match for other fields
  String area = (data['area'] ?? '').toString().toLowerCase();
  String bhk = (data['bhk'] ?? '').toString().toLowerCase();

  return area.contains(searchQuery) || bhk.contains(searchQuery);
}).toList();


                if (filteredDocs.isEmpty) {
                  return Center(child: Text('No properties found'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    var data = filteredDocs[index].data() as Map<String, dynamic>;
                    return _buildPropertyCard(data, screenWidth);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> data, double screenWidth) {
    return GestureDetector(
      onTap:() {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                PropertyDetailsPage(propertyData: data),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageLoader(
              data: data,
              screenWidth: screenWidth,
              screenHeight: screenWidth * 2.5, // Adjust height as needed
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'Property Name',
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        data['area'] ?? 'Location',
                        style: GoogleFonts.poppins(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.grey[700]),
                      ),
                      Icon(Icons.location_on, color: Colors.purple, size: MediaQuery.of(context).size.width * 0.05),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${data['bhk'] ?? '0'} BHK',
                        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Icon(Icons.currency_rupee, size: 18, color: Colors.pink),
                          Text(
                            '${data['rent'] ?? '0'}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
