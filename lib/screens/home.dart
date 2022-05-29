import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vimigo_test/screens/desc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPortrait = true;
  int? currentItemIndex;
  //1: phone, 2: phone(landscape), 3: tablet, 4:desktop
  int? deviceType;
  //Check whether it is portrait or landscape
  Future<void> determineLayout() async {
    final orientationType = MediaQuery.of(context).orientation;
    setState(() {
      if (Platform.isIOS || Platform.isAndroid) {
        if (orientationType == Orientation.landscape) {
          if (MediaQuery.of(context).size.width <= 750) {
            deviceType = 2;
          } else {
            deviceType = 3;
          }
          isPortrait = false;
          if (currentItemIndex == null) {
            setState(() {
              currentItemIndex = 0;
            });
          }
        } else {
          if (MediaQuery.of(context).size.width <= 750) {
            deviceType = 1;
          } else {
            deviceType = 3;
          }
          isPortrait = true;
          if (currentItemIndex != null) {
            final backItemIndex = currentItemIndex;
            WidgetsBinding.instance!.addPostFrameCallback(
              (timeStamp) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      debugPrint('backItemIndex: $backItemIndex');
                      return DescScreen(
                        itemIndex: backItemIndex ?? 0,
                        imageurl: 'assets/images/image_1.jpg',
                        deviceType: deviceType,
                      );
                    },
                  ),
                );
              },
            );
            setState(() {
              currentItemIndex = null;
            });
          }
        }
      } else {
        deviceType = 4;
        isPortrait = false;
      }
    });
    debugPrint('deviceType: $deviceType');
    debugPrint('isPortrait: $isPortrait');
  }

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
    final screenSize = MediaQuery.of(context).size;
    determineLayout();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Vimigo Test'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: !isPortrait ? screenSize.width * 0.3 : screenSize.width,
              child: Column(
                children: List.generate(8, (index) {
                  return ListTile(
                    selectedTileColor: Colors.blueGrey.shade200,
                    selectedColor: Colors.white,
                    selected: currentItemIndex == index ? true : false,
                    onTap: () {
                      determineLayout().then(
                        (_) {
                          if (isPortrait) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) {
                                  return DescScreen(
                                    itemIndex: index,
                                    imageurl: 'assets/images/image_1.jpg',
                                    deviceType: deviceType,
                                  );
                                },
                              ),
                            ).then((value) {
                              debugPrint(
                                  'isPortrait after return: $isPortrait');
                              setState(() {
                                if (!isPortrait) {
                                  currentItemIndex = value;
                                } else {
                                  debugPrint('sss');
                                  currentItemIndex = null;
                                }
                              });
                            });
                          } else {
                            setState(() {
                              currentItemIndex = index;
                            });
                          }
                        },
                      );
                    },
                    title: Text(
                      'Item ${index + 1}',
                      style: TextStyle(
                        fontWeight: currentItemIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                }),
              ),
            ),
          ),
          if (!isPortrait)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/image_1.jpg',
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.all(determinePadding()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Item ${(currentItemIndex ?? 0) + 1}'),
                          const SizedBox(height: 16),
                          Text(
                              'Some detail text for item ${(currentItemIndex ?? 0) + 1}'),
                          const SizedBox(height: 16),
                          const Text('Some more text for the detail view.')
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
