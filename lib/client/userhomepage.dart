import 'dart:async'; // Import for debouncing
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizapp/client/details.dart';
import 'package:quizapp/client/drawr.dart';
import 'package:quizapp/client/searchvies.dart';
import 'package:quizapp/services/sharedpreference.dart';
import 'imageloader.dart';

class UserViewPage extends StatefulWidget {
  const UserViewPage({Key? key}) : super(key: key);

  @override
  _UserViewPageState createState() => _UserViewPageState();
}

class _UserViewPageState extends State<UserViewPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = "";
  String _searchQuery = "";
  String userName = "User"; 
  Timer? _debounce; 

  // Add a GlobalKey for the Scaffold to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _searchFocusNode = FocusNode(); // FocusNode for the search field
   
   
   
   Future<void> _refreshProperties() async {
    // Adding a short delay to simulate a refresh action
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadUserName();
        _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose(); // Dispose FocusNode
    _debounce?.cancel(); // Cancel debounce timer
    super.dispose();
  }

  //Fetching user's name from SharedPreferences
  _loadUserName() async {
    String? savedName = await SharedpreferenceHelper().getUserName();
    if (savedName != null && savedName.isNotEmpty) {
      setState(() {
        userName = savedName;
      });
    }
  }

  // Debounced search change handler
  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Stream<List<QueryDocumentSnapshot>> _getFilteredProperties() {
  Query query = _firestore.collection('properties');

  // Apply BHK or Rent Range Filter
  if (selectedFilter.isNotEmpty) {
    if (selectedFilter == "1 BHK") {
      query = query.where('bhk', isEqualTo: "1 BHK");
    } else if (selectedFilter == "2 BHK") {
      query = query.where('bhk', isEqualTo: "2 BHK");
    } else if (selectedFilter == "5K-10K") {
      query = query
          .where('rent', isGreaterThanOrEqualTo: "5000")
          .where('rent', isLessThanOrEqualTo: "10000");
    } else if (selectedFilter == "10K-15K") {
      query = query
          .where('rent', isGreaterThanOrEqualTo: 10000)
          .where('rent', isLessThanOrEqualTo: 15000);
    }
  }

  // Filter locally for the search query
  return query.snapshots().map((snapshot) {
    if (_searchQuery.isEmpty) {
      return snapshot.docs;
    }

    return snapshot.docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final name = (data['name'] ?? '').toString().toLowerCase();
      final area = (data['area'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery) || area.contains(_searchQuery);
    }).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawerpage(),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.06,
                  top: MediaQuery.of(context).size.height * 0.08,
                  child: IconButton(
                    icon: Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
                 Positioned(
                  left: MediaQuery.of(context).size.width * 0.09,
                  top: MediaQuery.of(context).size.height * 0.17,
                  child: Row(
                    children: [
                      Text(
                        "Hi, ",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DefaultTextStyle(
                        style: GoogleFonts.poppins(
                          color: Colors.pink,
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              userName,
                              speed: const Duration(milliseconds: 150),
                            ),
                          ],
                          totalRepeatCount: 1000,
                          isRepeatingAnimation: true, 
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.09,
                  top: MediaQuery.of(context).size.height * 0.21,
                  child: Text(
                    "Hunting Homes? We're Here to Help! ",
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height * 0.25,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        readOnly: true, 
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Searchview(initialQuery: _searchController.text),
                            ),
                          );
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.cancel, color: Colors.black),
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                    });
                                    FocusScope.of(context).unfocus(); 
                                  },
                                )
                              : null,
                          hintText: "Search Property Here",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.withOpacity(0.5),
                            fontSize: MediaQuery.of(context).size.width * 0.034,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ),Positioned(
                  left: MediaQuery.of(context).size.width * 0.15,
                  top: MediaQuery.of(context).size.height * 0.35,
                  child: Text(
                    "Discover the Perfect Place to Call Home",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProperties,
              child: StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: _getFilteredProperties(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No properties available.'));
                }

                final properties = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    final data = property.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
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
                      child: _buildPropertyCard(data, screenWidth, screenHeight),
                    );
                  },
                );
              },
            ),
          ),)
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> data, double screenWidth, double screenHeight) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      elevation: 10,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 10, top: 15),
      child: Column(
        children: [
          ImageLoader(
            data: data,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data['name'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${data['bhk'] ?? ''} BHK',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 11, right: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      data['area'] ?? '',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(Icons.location_on, size: screenWidth * 0.05, color: Colors.purple),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.currency_rupee, size: screenWidth * 0.05, color: Colors.pink),
                    const SizedBox(width: 5),
                    Text(
                      '${data['rent'] ?? ''}',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
