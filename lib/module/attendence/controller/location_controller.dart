import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/attendence/controller/attendence_report_controller.dart';
import 'package:trealapp/module/attendence/model/attendence_submit_model.dart';
import 'package:trealapp/module/attendence/model/company_details_model.dart';
import 'package:trealapp/module/attendence/repo/attendence_submit_repo.dart';
import 'dart:math' as math;
import 'package:app_settings/app_settings.dart';

class LocationController extends GetxController with WidgetsBindingObserver {
  AttendenceSubmitRepo? attendenceSubmitRepo;
  LocationController({this.attendenceSubmitRepo});

// Location Variable
  var lat = ''.obs;
  var lon = ''.obs;
  var address = ''.obs;
  var currentLocation = const LatLng(0, 0).obs;
  var cameraPosition = const LatLng(0, 0).obs;
  var isLocationFetched = false.obs;
  var mockAddress = ''.obs;
  Rx<EdgeInsets> mapPadding = EdgeInsets.zero.obs;
  static bool isDialogShown = false;

// Time Variable
  final RxString date = ''.obs;
  final RxString time = ''.obs;
  final RxString meridiem = ''.obs;
  final RxString seconds = ''.obs;

  // ignore: unused_field
  late Timer _timer;
  var timeLoading = false.obs;
  late DateTime initialTime =
      DateTime.now(); // Stores the initial time fetched from the API
  // Initialize it first to avoid endless looping
  bool isStreamingActive = false;

// Office Time Variable
  final RxString officeTimeIn = "".obs;
  final RxString officeTimeOut = "".obs;
  final RxString officeTimeInHeading = "Office In".obs;
  final RxString officeTimeOutHeading = "Office Out".obs;
  var isCompanyLoading = false.obs;

  bool _hasFocus = false; // To prevent looping on focus change

// Map Controlller and Completer
  Completer<GoogleMapController> mapControllerCompleter = Completer();
  late GoogleMapController mapController;

// Late Note Text Edit controller
  final TextEditingController lateInNoteController = TextEditingController();

  final AttendenceReportController attendenceReportController =
      Get.find<AttendenceReportController>();

  // void updatePadding(double newPadding) {
  //   mapPadding.value = newPadding;
  // }

  void onMapCreated(GoogleMapController controller) {
    // Complete the controller only once
    if (!mapControllerCompleter.isCompleted) {
      mapControllerCompleter.complete(controller);
      mapController = controller;
    } else {
      mapController = controller;
    }
  }

  void updateCameraPositionWithPadding({EdgeInsets padding = EdgeInsets.zero}) {
    mapPadding.value = padding;
    update();
  }

  void resetMapControllerCompleter() {
    // Reset the completer each time the page is initialized
    mapControllerCompleter = Completer<GoogleMapController>();
  }

  @override
  void onInit() {
    super.onInit();
    // Register the controller to observe lifecycle changes
    WidgetsBinding.instance.addObserver(this);
// Reset the completer when the controller is initialized
  }

// streming Word-Time
  void startStreamingTime() async {
    timeLoading(true); // Assuming `timeLoading` updates a reactive variable
    await _fetchAndProcessTime();
    timeLoading(false);

    _startUpdatingTime(); // If you have a separate logic for periodic updates
    update(); // Assuming this updates the necessary UI bindings
    isStreamingActive = false; // Ensure flag resets after successful initiation
  }

// fetch world time
  Future<void> _fetchAndProcessTime() async {
    try {
      Response response = await attendenceSubmitRepo!.getCurrentTime();
      var officeCurrentTime = response.body["data"]["current_time"];
// Parse the officeCurrentTime string into a DateTime object
      initialTime =
          DateFormat('yyyy-MM-dd hh:mm:ss a').parse(officeCurrentTime);
      // Format the date and time for display
      date.value = DateFormat('EEEE, dd MMMM yy').format(initialTime);
      time.value =
          DateFormat('hh:mm').format(initialTime); // Time part (HH:MM:SS)
      meridiem.value = DateFormat('a').format(initialTime); // AM/PM part
    } catch (e) {
      initialTime = DateTime.now();
      // DialogUtils().errorSnackBar('Failed to fetch time. Please try again.');
    }
  }

  // Update the time every second
  void _startUpdatingTime() {
    // ignore: unnecessary_null_comparison
    if (initialTime == null) return; // Short-circuit if not initialized

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      // Increment the initial time by one second
      initialTime = initialTime.add(const Duration(seconds: 1));
      // Update the observable time with the new value
      time.value = DateFormat('hh:mm').format(initialTime);
      meridiem.value = DateFormat('a').format(initialTime); // AM/PM part
      date.value = DateFormat('EEEE, dd MMMM yy').format(initialTime);
      seconds.value = initialTime.second.toString().padLeft(2, "0");
      update();
    });
  }

  String timeConverterToHousAndMinute(String time) {
    DateTime officeInTime = DateFormat("HH:mm:ss").parse(time);
    String formateTime = DateFormat("hh:mm a").format(officeInTime);
    return formateTime;
  }

  // Geo Current Location
  Future<void> getCurrentLocation() async {
    // Check for location permission
    bool hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      return;
    }

    // Set location settings
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // Get all location updates
      // timeLimit: Duration(seconds: 10), // Timeout after 10 seconds
    );

    try {
      // Fetch current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      // Check if the location is mocked
      if (position.isMocked) {
        showMockLocationDialog();
        return;
      }

      // Fetch address details
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        updateLocationInfo(position, placemarks[0]);
        // Wait for the mapController to be initialized
        if (mapControllerCompleter.isCompleted) {
          // Wait for the map to be created and mapController to be available
          // final GoogleMapController controller =
          //     await mapControllerCompleter.future;
          // await controller.animateCamera(
          //   CameraUpdate.newLatLng(currentLocation.value),
          // );

          mapController.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(
              target: cameraPosition.value,
              zoom: 16,
            )),
          );
        } else {
          // Get.snackbar("Error", "MapController not yet ready.");
          return;
        }
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  void showMockLocationDialog() {
    Get.dialog(
      Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 72),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.close_outlined, color: redColor, size: 96),
                Text(
                  "Unauthorized Use of Mock API",
                  style: TextStyle(
                    color: redColor,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateLocationInfo(Position position, Placemark place) {
    // Update the observable variables
    currentLocation.value = LatLng(position.latitude, position.longitude);
    cameraPosition.value = LatLng(position.latitude, position.longitude);
    lat.value = '${position.latitude}';
    lon.value = '${position.longitude}';
    address.value =
        '${place.thoroughfare}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.country}';
    isLocationFetched.value = true;
  }

  // Geo Location Permission
  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text(
            'Enable Location Services',
            style: TextStyles.title18,
          ),
          content: Text(
            'Location services are disabled. Would you like to enable them?',
            style: TextStyles.regular14,
          ),
          actions: <Widget>[
            TextButton(
              // style: ButtonStyle(),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: Text(
                'Cancel',
                style: TextStyles.title14.copyWith(color: redColor),
              ),
            ),
            TextButton(
              onPressed: () {
                AppSettings.openAppSettings(type: AppSettingsType.location);
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: Text(
                'Open Settings',
                style: TextStyles.title14.copyWith(color: blueColor),
              ),
            ),
          ],
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Snack Bar Ui change In location premisson Denied
        showPermissionDenied();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever && !isDialogShown) {
      isDialogShown = true;
      showPermissionDeniedDialog();
      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<void> showPermissionDenied() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Permission Denied',
            style: TextStyles.title18,
          ),
          content: Text(
            'Location permissions are denied, and we cannot request permissions. Please enable them in your device settings.',
            style: TextStyles.regular14,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => {
                isDialogShown = false,
                Navigator.of(context).pop(), // Dismiss the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyles.title14.copyWith(color: redColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                AppSettings.openAppSettings(type: AppSettingsType.settings);
              },
              child: Text(
                'Open Settings',
                style: TextStyles.title14.copyWith(
                    color: blueColor), // Adjust your color or style as needed
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showPermissionDeniedDialog() async {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Permission Denied Permanently',
            style: TextStyles.title18,
          ),
          content: Text(
            'Location permissions are permanently denied, and we cannot request permissions. Please enable them in your device settings.',
            style: TextStyles.regular14,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => {
                isDialogShown = false,
                Navigator.of(context).pop(), // Dismiss the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyles.title14.copyWith(color: redColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                AppSettings.openAppSettings(type: AppSettingsType.settings);
              },
              child: Text(
                'Open Settings',
                style: TextStyles.title14.copyWith(
                    color: blueColor), // Adjust your color or style as needed
              ),
            ),
          ],
        );
      },
    );
  }

  // submit  Late Note
  Future<void> sendLateInNote() async {
    try {
      DialogUtils.showLoading(title: "Please Wait");
      final Map<String, dynamic> noteBody = <String, dynamic>{};
      noteBody["note"] = lateInNoteController.text;
      Response response = await attendenceSubmitRepo!.sendLateInNote(noteBody);
      DialogUtils.closeLoading();
      if (response.statusCode == 200) {
        Get.back();
        DialogUtils.successMessage(title: "Thank You");
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  // Methods
  // submit check in
  Future<void> checkInSubmitMethod() async {
    try {
      AttendanceSubmitModel attendanceSubmitModel;
      DialogUtils.showLoading(title: "Please Wait");
      await getCurrentLocation();
      final Map<String, dynamic> checkInBody = <String, dynamic>{};
      checkInBody['in_latitude'] = lat.value;
      checkInBody['in_longitude'] = lon.value;
      Response response =
          await attendenceSubmitRepo!.submitCheckIN(checkInBody);
      DialogUtils.closeLoading();
      if (response.statusCode == 201) {
        attendanceSubmitModel = AttendanceSubmitModel.fromJson(response.body);
        bool? isLate = attendanceSubmitModel.data?.isLate;
        String? successMessage = attendanceSubmitModel.message;
        if (isLate!) {
          Get.bottomSheet(Material(
              color: Colors.transparent,
              child: Container(
                height: 170,
                decoration: const BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  children: [
                    Text(
                      successMessage!,
                      style: TextStyles.regular12.copyWith(
                          fontWeight: FontWeight.w600, color: cyanColor),
                    ),
                    const SizedBoxHight(),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      controller: lateInNoteController,
                      maxLines: null,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.note_alt_outlined),
                        hintText: "Write your late-in Note",
                        hintStyle: TextStyle(color: Colors.black45),
                      ),
                    ),
                    const SizedBoxHight(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              sendLateInNote();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 15, right: 15),
                              backgroundColor: blueColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(6), // <-- Radius
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Transform.rotate(
                                    angle: -45 * math.pi / 180,
                                    child: const Icon(
                                      Icons.send_sharp,
                                      color: whiteColor,
                                    )),
                                Text(
                                  "Send",
                                  style: TextStyles.regular16
                                      .copyWith(color: whiteColor),
                                )
                              ],
                            ))
                      ],
                    )
                  ],
                ),
              )));
        } else {
          DialogUtils.successMessage(title: "Success");
          lat.value = "";
          lon.value = "";
        }
        await attendenceReportController.getUserAttendenceReports();
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  // submit check out
  Future<void> checkOutSubmitMethod() async {
    try {
      // AttendanceSubmitModel attendanceSubmitModel;
      DialogUtils.showLoading(title: "Please Wait");
      await getCurrentLocation();
      final Map<String, dynamic> checkOutBody = <String, dynamic>{};
      checkOutBody["out_latitude"] = lat.value;
      checkOutBody['out_longitude'] = lon.value;
      Response response =
          await attendenceSubmitRepo!.submitCheckOut(checkOutBody);
      DialogUtils.closeLoading();
      if (response.statusCode == 200) {
        DialogUtils.successMessage(title: "Success");
        lat.value = "";
        lon.value = "";
        await attendenceReportController.getUserAttendenceReports();
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

// fetch company Details
  Future<void> fectchCompanyDetails() async {
    try {
      isCompanyLoading(true);
      Response response = await attendenceSubmitRepo!.userCompanyDetails();
      if (response.statusCode == 200) {
        CompanyDetailsModel companyDetailsModel;
        companyDetailsModel = CompanyDetailsModel.fromJson(response.body);

        officeTimeIn.value = timeConverterToHousAndMinute(
            companyDetailsModel.data!.officeStartTime!);
        officeTimeOut.value = timeConverterToHousAndMinute(
            companyDetailsModel.data!.officeEndTime!);
      }
      isCompanyLoading(false);
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (!_hasFocus) {
        // App has regained focus, perform necessary updates

        refreshMap();
        _hasFocus =
            true; // Mark that the app is in focus to avoid repeating the same actions
      }
    } else if (state == AppLifecycleState.paused) {
      // App has lost focus
      _hasFocus = false; // Mark that the app has lost focus
    }
  }

  void refreshMap() async {
    // You can trigger a re-render or update map state here
    await getCurrentLocation();
    // _timer.cancel();
    startStreamingTime();
    update();
  }

  @override
  void onClose() {
    // Make sure to cancel the timer to avoid leaks
    // _timer.cancel();
    // _timeStreamController.close();
    // Remove observer when the controller is closed
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
