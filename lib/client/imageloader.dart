import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';

class ImageLoader extends StatefulWidget {
  final Map<String, dynamic> data;
  final double screenWidth;
  final double screenHeight;

  const ImageLoader({
    required this.data,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  _ImageLoaderState createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      setState(() {
        isConnected = connectivityResult != ConnectivityResult.none;
        if (!isConnected) {
          debugPrint("No Internet Connection");
        }
      });
    });
  }

  void checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
      if (!isConnected) {
        debugPrint("No Internet Connection");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Adds a background color to differentiate from white
      width: widget.screenWidth,
      height: widget.screenHeight * 0.2,
      child: isConnected
          ? widget.data['images'] != null && (widget.data['images'] as List).isNotEmpty
              ? Image.network(
                  widget.data['images'][0],
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: Lottie.asset('assets/images/load1.json', width: 150, height: 150),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint("Image load error: $error");
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/images/some.json', width: MediaQuery.of(context).size.width * 0.5, height: MediaQuery.of(context).size.width * 0.3),
                          SizedBox(height: 10),
                          Text(
                            "Failed to load image",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/images/servererror.json', width: MediaQuery.of(context).size.width * 0.05, height: MediaQuery.of(context).size.width * 0.05),
                      SizedBox(height: 10),
                      Text(
                        "No Images Available",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/networkerror.json', width: 100, height: 100),
                  SizedBox(height: 10),
                  Text(
                    "No Internet Connection",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
