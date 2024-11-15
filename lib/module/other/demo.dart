import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(displayWidth * .05),
        height: displayWidth * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                currentIndex = index;
                HapticFeedback.lightImpact();
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == currentIndex
                      ? displayWidth * .32
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    height: index == currentIndex ? displayWidth * .12 : 0,
                    width: index == currentIndex ? displayWidth * .32 : 0,
                    decoration: BoxDecoration(
                      color: index == currentIndex
                          ? Colors.blueAccent.withOpacity(.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: index == currentIndex
                      ? displayWidth * .31
                      : displayWidth * .18,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .13 : 0,
                          ),
                          AnimatedOpacity(
                            opacity: index == currentIndex ? 1 : 0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Text(
                              index == currentIndex ? listOfStrings[index] : '',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            width:
                                index == currentIndex ? displayWidth * .03 : 20,
                          ),
                          Icon(
                            listOfIcons[index],
                            size: displayWidth * .076,
                            color: index == currentIndex
                                ? Colors.blueAccent
                                : Colors.black26,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
    Icons.person_rounded,
  ];

  List<String> listOfStrings = [
    'Home',
    'Favorite',
    'Settings',
    'Account',
  ];
}



  // buildBottomNavigationMenu(context, landingPageController) {
  //   return Obx(() => MediaQuery(
  //       data: MediaQuery.of(context)
  //           .copyWith(textScaler: const TextScaler.linear(1.0)),
  //       child: SizedBox(
  //         height: 58,
  //         child: BottomNavigationBar(
  //           showUnselectedLabels: true,
  //           showSelectedLabels: true,
  //           onTap: landingPageController.changeTabIndex,
  //           currentIndex: landingPageController.tabIndex.value,
  //           backgroundColor: const Color(0xFF243665),
  //           unselectedItemColor: Colors.white.withOpacity(0.5),
  //           selectedItemColor: Colors.white,
  //           unselectedLabelStyle: unselectedLabelStyle,
  //           selectedLabelStyle: selectedLabelStyle,
  //           items: [
  //             BottomNavigationBarItem(
  //               icon: Container(
  //                 margin: const EdgeInsets.only(bottom: 4),
  //                 child: const Icon(
  //                   Icons.home_outlined,
  //                   size: 20.0,
  //                 ),
  //               ),
  //               label: 'Home',
  //               backgroundColor: const Color(0xFF243665),
  //             ),
  //             BottomNavigationBarItem(
  //               icon: Container(
  //                 margin: const EdgeInsets.only(bottom: 4),
  //                 child: const Icon(
  //                   Icons.access_time,
  //                   size: 20.0,
  //                 ),
  //               ),
  //               label: 'Attendence',
  //               backgroundColor: const Color(0xFF243665),
  //             ),
  //             BottomNavigationBarItem(
  //               icon: Container(
  //                 margin: const EdgeInsets.only(bottom: 4),
  //                 child: const Icon(
  //                   Icons.description_outlined,
  //                   size: 20.0,
  //                 ),
  //               ),
  //               label: 'Approval',
  //               backgroundColor: const Color(0xFF243665),
  //             ),
  //             BottomNavigationBarItem(
  //               icon: Container(
  //                 margin: const EdgeInsets.only(bottom: 4),
  //                 child: const Icon(
  //                   Icons.description_outlined,
  //                   size: 20.0,
  //                 ),
  //               ),
  //               label: 'Demo',
  //               backgroundColor: const Color(0xFF243665),
  //             ),
  //           ],
  //         ),
  //       )));
  // }



  // buildBottomNavigationMenu(context) {
  //   double displayWidth = MediaQuery.of(context).size.width;
  //   return Container(
  //     margin: EdgeInsets.all(displayWidth * .05),
  //     height: displayWidth * .155,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(.1),
  //           blurRadius: 30,
  //           offset: const Offset(0, 10),
  //         ),
  //       ],
  //       borderRadius: BorderRadius.circular(50),
  //     ),
  //     child: ListView.builder(
  //       itemCount: 3, // Adjusted to 3 since there are 3 tabs
  //       scrollDirection: Axis.horizontal,
  //       padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
  //       itemBuilder: (context, index) => InkWell(
  //         onTap: () {
  //           onTabTapped(index);
  //         },
  //         splashColor: Colors.transparent,
  //         highlightColor: Colors.transparent,
  //         child: Stack(
  //           children: [
  //             Expanded(
  //               child: AnimatedContainer(
  //                 duration: const Duration(seconds: 1),
  //                 curve: Curves.fastLinearToSlowEaseIn,
  //                 width: index == currentIndex
  //                     ? displayWidth * .32
  //                     : displayWidth * .18,
  //                 alignment: Alignment.center,
  //                 child: AnimatedContainer(
  //                   duration: const Duration(seconds: 1),
  //                   curve: Curves.fastLinearToSlowEaseIn,
  //                   height: index == currentIndex ? displayWidth * .12 : 0,
  //                   width: index == currentIndex ? displayWidth * .32 : 0,
  //                   decoration: BoxDecoration(
  //                     color: index == currentIndex
  //                         ? Colors.blueAccent.withOpacity(.2)
  //                         : Colors.transparent,
  //                     borderRadius: BorderRadius.circular(50),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Expanded(
  //               child: AnimatedContainer(
  //                 duration: const Duration(seconds: 1),
  //                 curve: Curves.fastLinearToSlowEaseIn,
  //                 width: index == currentIndex
  //                     ? displayWidth * .31
  //                     : displayWidth * .18,
  //                 alignment: Alignment.center,
  //                 child: Stack(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: AnimatedContainer(
  //                             duration: const Duration(seconds: 1),
  //                             curve: Curves.fastLinearToSlowEaseIn,
  //                             width: index == currentIndex
  //                                 ? displayWidth * .14
  //                                 : 0,
  //                           ),
  //                         ),
  //                         AnimatedOpacity(
  //                           opacity: index == currentIndex ? 1 : 0,
  //                           duration: const Duration(seconds: 1),
  //                           curve: Curves.fastLinearToSlowEaseIn,
  //                           child: Expanded(
  //                             child: Text(
  //                               index == currentIndex
  //                                   ? listOfStrings[index]
  //                                   : '',
  //                               style: const TextStyle(
  //                                 color: Colors.blueAccent,
  //                                 fontWeight: FontWeight.w600,
  //                                 fontSize: 14,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Row(
  //                       children: [
  //                         AnimatedContainer(
  //                           duration: const Duration(seconds: 1),
  //                           curve: Curves.fastLinearToSlowEaseIn,
  //                           width:
  //                               index == currentIndex ? displayWidth * .03 : 20,
  //                         ),
  //                         Icon(
  //                           listOfIcons[index],
  //                           size: displayWidth * .074,
  //                           color: index == currentIndex
  //                               ? Colors.blueAccent
  //                               : Colors.black26,
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }