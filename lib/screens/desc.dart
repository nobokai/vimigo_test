import 'package:flutter/material.dart';

class DescScreen extends StatelessWidget {
  final int itemIndex;
  final String imageurl;
  final int? deviceType;
  const DescScreen(
      {Key? key,
      required this.itemIndex,
      required this.imageurl,
      this.deviceType})
      : super(key: key);

  //Determine padding based on device size
  double determinePadding() {
    double? value;
    switch (deviceType) {
      case 1:
        value = 12;
        break;
      case 2:
        value = 16;
        break;
      case 3:
        value = 18;
        break;
      case 4:
        value = 20;
        break;
    }
    return value!;
  }

  @override
  Widget build(BuildContext context) {
    final orientationType = MediaQuery.of(context).orientation;
    if (orientationType == Orientation.landscape) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        return Navigator.of(context).pop(itemIndex);
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Descriptions'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(determinePadding()),
              child: Material(
                clipBehavior: Clip.hardEdge,
                elevation: 30,
                child: Image(
                  image: AssetImage(imageurl),
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: child,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(determinePadding()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Item ${itemIndex + 1}'),
                  const SizedBox(height: 16),
                  Text('Some detail text for item ${itemIndex + 1}'),
                  const SizedBox(height: 16),
                  const Text('Some more text for the detail view.')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
