import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/attendence/controller/animation_button_contrroller.dart';
import 'package:trealapp/module/attendence/controller/location_controller.dart';
import 'package:trealapp/module/attendence/view/animation_button.dart';

class AttendenceSubmitScreen extends StatefulWidget {
  const AttendenceSubmitScreen({super.key});

  @override
  State<AttendenceSubmitScreen> createState() => _AttendenceSubmitScreenState();
}

class _AttendenceSubmitScreenState extends State<AttendenceSubmitScreen> {
  late GoogleMapController mapController;

  final LocationController locationController = Get.find<LocationController>();

  final AnimatedButtonController animationController =
      Get.find<AnimatedButtonController>();

  @override
  void initState() {
    super.initState();

    locationController.resetMapControllerCompleter();
    locationController.fectchCompanyDetails();
    locationController.startStreamingTime();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) async {},
      child: Scaffold(
        backgroundColor: whiteColor,
        body: LayoutBuilder(builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: animationController.onRefreshing,
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Obx(() {
                            if (!locationController.isLocationFetched.value) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          .2),
                                  child: const Column(
                                    children: [
                                      CircularProgressIndicator(),
                                    ],
                                  ));
                            }
                            return FutureBuilder(
                                future: Future.delayed(
                                    const Duration(milliseconds: 200)),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }

                                  return GetBuilder<LocationController>(
                                      initState: (_) {
                                    // Setting padding to move the marker to the top when the page is opened
                                    locationController
                                        .updateCameraPositionWithPadding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.56),
                                    );
                                    locationController.getCurrentLocation();
                                  }, builder: (context) {
                                    return GoogleMap(
                                      padding:
                                          locationController.mapPadding.value,
                                      myLocationButtonEnabled: true,
                                      onMapCreated:
                                          locationController.onMapCreated,
                                      initialCameraPosition: CameraPosition(
                                        target: locationController
                                            .cameraPosition.value,
                                        zoom: 16.0,
                                      ),
                                      markers: {
                                        Marker(
                                            icon: BitmapDescriptor
                                                .defaultMarkerWithHue(
                                                    BitmapDescriptor.hueBlue),
                                            markerId: const MarkerId(
                                                "currentLocation"),
                                            position: locationController
                                                .currentLocation.value,
                                            infoWindow: InfoWindow(
                                                title:
                                                    '${locationController.address}'))
                                      },
                                      myLocationEnabled: false,
                                      mapType: MapType.normal,

                                      // liteModeEnabled: true,
                                    );
                                  });
                                });
                          }),

                          Positioned(
                              top: Dimensions.top280,
                              right: Dimensions.right60,
                              child: FloatingActionButton.small(
                                onPressed: () async {
                                  await locationController.getCurrentLocation();
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                backgroundColor: blueColor,
                                child: const Icon(
                                  Icons.location_searching,
                                  color: whiteColor,
                                ),
                              )),

                          /// Back Button
                          Positioned(
                            top: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 20,
                              right: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text("Attendence",
                                    style: TextStyles.regular14.copyWith(
                                        color: lightGrayColor,
                                        fontWeight: FontWeight.w600)),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  // top: constraints.maxHeight * .45,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(top: 25),
                      child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: _buildBottomContainer())),
                ),
              ],
            ),
          );
        }),
      ),
    ));
  }

  Widget _buildBottomContainer() {
    return Column(
      children: [
        Obx(() {
          if (locationController.timeLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    locationController.time.value,
                    style: TextStyles.title32.copyWith(
                        fontSize: Dimensions.font36,
                        fontWeight: FontWeight.normal,
                        color: lightGrayColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.padding08),
                    child: Text(
                      locationController.seconds.value,
                      style: TextStyles.regular14.copyWith(
                          color: lightGrayColor, fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              Text(
                locationController.meridiem.value,
                style: TextStyles.regular14.copyWith(
                    color: lightGrayColor2, fontWeight: FontWeight.w600),
              )
            ],
          );
        }),
        SizedBoxHight(
          hieght: Dimensions.height08,
        ),
        Obx(() => Text(
              locationController.date.value,
              style: TextStyles.regular16.copyWith(
                  fontSize: Dimensions.font20,
                  color: const Color.fromARGB(255, 143, 143, 143)),
            )),
        Obx(() => SizedBoxHight(
              hieght: locationController.timeLoading.value
                  ? Dimensions.height20
                  : Dimensions.height20,
            )),
        Padding(
          padding: EdgeInsets.only(
              left: Dimensions.padding20, right: Dimensions.padding20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.place,
                color: blueColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Obx(() => Text(
                      "${locationController.address}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.regular12.copyWith(
                          fontWeight: FontWeight.w600, color: lightGrayColor),
                    )),
              ),
            ],
          ),
        ),
        Obx(() => SizedBoxHight(
              hieght: locationController.timeLoading.value
                  ? Dimensions.height15
                  : Dimensions.height10,
            )),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: lightGrayColor2),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          margin: EdgeInsets.only(
              left: Dimensions.margin20, right: Dimensions.margin20),
          // padding: const EdgeInsets.only(bottom: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        right: BorderSide(width: 1.5, color: lightGrayColor2)),
                  ),
                  padding: EdgeInsets.only(
                      bottom: Dimensions.padding20, top: Dimensions.padding20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            size: Dimensions.icon16,
                            color: cyanColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Obx(
                            () => Text(
                              locationController.officeTimeInHeading.value,
                              style: TextStyles.regular12.copyWith(
                                  color: cyanColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                      const SizedBoxHight(
                        hieght: 5,
                      ),
                      Center(
                        child: Obx(() {
                          if (locationController.isCompanyLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Text(
                            locationController.officeTimeIn.value,
                            style: TextStyles.title20
                                .copyWith(color: lightGrayColor),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: Dimensions.padding20, top: Dimensions.padding20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: Dimensions.icon16,
                            color: blueColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Obx(() => Text(
                                locationController.officeTimeOutHeading.value,
                                style: TextStyles.regular12.copyWith(
                                    color: blueColor,
                                    fontWeight: FontWeight.w600),
                              ))
                        ],
                      ),
                      const SizedBoxHight(
                        hieght: 5,
                      ),
                      Obx(() {
                        if (locationController.isCompanyLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Text(
                          locationController.officeTimeOut.value,
                          style: TextStyles.title20
                              .copyWith(color: lightGrayColor),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBoxHight(
          hieght: Dimensions.height20,
        ),
        AnimationButton(),
      ],
    );
  }
}
