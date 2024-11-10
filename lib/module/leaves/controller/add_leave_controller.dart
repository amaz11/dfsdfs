// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';
import 'package:trealapp/module/leaves/model/add_leave_model.dart';
import 'package:trealapp/module/leaves/model/leave_days_count.dart';
import 'package:trealapp/module/leaves/repo/add_leave_repo.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:trealapp/module/leaves/view/add_leaves_screen.dart';

class AddLeaveController extends GetxController {
  AddLeaveRepo? addLeaveRepo;

  AddLeaveController({this.addLeaveRepo});
  var selectedValue = 0.obs;
  var updateId = 0.obs;
  var dropdownItems =
      <LeaveType>[].obs; // Empty observable list to hold dropdown items
  var isLoading = true.obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  var isHalfDay = false.obs;

// File Upload variable
  var selectedFile = Rx<File?>(null);
  var isUploading = false.obs;
  static const int maxFileSize = 5 * 1024 * 1024; // 5 MB
  RxString attachment = "".obs;

// Leaves Days Count
  RxString leaveDaysCount = "0".obs;
  var selectedLeaveType = LeaveTypeEnum.fullDay.obs;

// text controller
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();
  final reasonController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
  }

  set toggleHalfDay(bool value) {
    isHalfDay.value = value;
    update();
  }

  bool get toggleHalfDay => isHalfDay.value;

  // Select image from the gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      final File file = File(image.path);
      final int fileSize = await file.length();

      if (fileSize <= maxFileSize) {
        selectedFile.value = file;
        await uploadFile();
      } else {
        DialogUtils().errorSnackBar(
            "File size exceeds 5 MB. Please select a smaller file.");
      }
    }
  }

  // Select PDF file
  Future<void> pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
    );
    if (result != null && result.files.single.path != null) {
      final File file = File(result.files.single.path!);
      final int fileSize = await file.length();

      if (fileSize <= maxFileSize) {
        selectedFile.value = file;
        await uploadFile();
      } else {
        DialogUtils().errorSnackBar(
            "File size exceeds 5 MB. Please select a smaller file.");
      }
    }
  }

  void selectStartDate(BuildContext context) async {
    // ignore: unused_local_variable
    final pickedDate = await datePicker(context, "Start date");
    // if (pickedDate != null && pickedDate != fromDate.value) {
    //   fromDate.value = pickedDate;
    //   fromDateController.text = DateFormat('dd-MM-yyyy').format(fromDate.value);

    //   // Auto-advance to End Date if Full Day leave type is selected
    //   if (selectedLeaveType.value == LeaveTypeEnum.fullDay) {
    //     // ignore: use_build_context_synchronously
    //     // print("object");
    //     selectEndDate(context);
    //   }
    //   // Only calculate days if both dates are selected
    //   if (toDateController.text.isNotEmpty) {
    //     await leavesDaysCounts();
    //   }
    //   update();
    // }
  }

  // Future selectEndDate(BuildContext context) async {
  //   DateTime? pickedDate = await datePicker(context, "End date");
  //   if (pickedDate != null && pickedDate != toDate.value) {
  //     toDate.value = pickedDate;
  //     toDateController.text = DateFormat('dd-MM-yyyy').format(toDate.value);

  //     // Only calculate days if the start date is already selected
  //     if (fromDateController.text.isNotEmpty) {
  //       await leavesDaysCounts();
  //     }
  //     update();
  //   }
  // }

  Future datePicker(BuildContext context, String title) async {
    // Use the selected date from the controller if it exists
    DateTime selectedDate = DateTime.now();
    // ignore: no_leading_underscores_for_local_identifiers, unused_local_variable
    DateRangePickerController _dateRangePickerController =
        DateRangePickerController();
    // if (fromDateController.text.isNotEmpty) {
    //   fromDateController.clear();
    // }
    // if (toDateController.text.isNotEmpty) {
    //   toDateController.clear();
    // }
    if (isHalfDay.value) {
      Get.dialog(Dialog(
        backgroundColor: whiteColor,
        child: Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors
                  .blue, // Header background color and selected date color
              onPrimary: Colors
                  .white, // Color for text on the header and selected date
              onSurface: Colors.black, // Color for days and month text
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBoxHight(hieght: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Select Date",
                  style: TextStyles.title18,
                ),
              ),
              const SizedBoxHight(hieght: 10),
              CalendarDatePicker(
                initialDate: selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(selectedDate.year + 100),
                onDateChanged: (DateTime value) async {
                  String pickedDate = DateFormat('dd-MM-yyyy').format(value);
                  fromDateController.text = pickedDate;
                  update();
                },
              ),
            ],
          ),
        ),
      ));
    } else {
      Get.dialog(Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 370,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: whiteColor,
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Select Date Range",
                  style: TextStyles.title18,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SfDateRangePicker(
                headerStyle: DateRangePickerHeaderStyle(
                    backgroundColor: whiteColor, textStyle: TextStyles.title16),
                headerHeight: 50,
                rangeSelectionColor: blueColor.withOpacity(0.2),
                selectionColor: blueColor,
                todayHighlightColor: blueColor,
                startRangeSelectionColor: blueColor,
                endRangeSelectionColor: blueColor,
                // controller: _dateRangePickerController,
                view: DateRangePickerView.month,
                backgroundColor: whiteColor,
                selectionMode: DateRangePickerSelectionMode.range,
                // onSelectionChanged: _onSelectionChange,
                showActionButtons: true,
                onCancel: () {
                  Get.back();
                },
                onSubmit: (pickedDate) async {
                  // Cast `pickedDate` as `PickerDateRange`
                  final dateRange = pickedDate as PickerDateRange?;

                  if (dateRange != null) {
                    DateTime? startDate = dateRange.startDate;
                    DateTime? endDate = dateRange.endDate;

                    if (startDate != null && endDate != null) {
                      // You can format and set the values in your controllers here
                      fromDateController.text =
                          DateFormat('dd-MM-yyyy').format(startDate);
                      toDateController.text =
                          DateFormat('dd-MM-yyyy').format(endDate);

                      await leavesDaysCounts();
                      Get.back();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ));
    }
  }

  Future<void> fetchDropdownData() async {
    try {
      Response response = await addLeaveRepo!.getLeaveType();

      if (response.statusCode == 200) {
        AddLeaveModel addLeaveModel;

        addLeaveModel = AddLeaveModel.fromJson(response.body);

        // Assuming the API returns a list of items
        dropdownItems.value = addLeaveModel.leaveTypes!;

        // ignore: invalid_use_of_protected_member
        if (Get.currentRoute == "/update-leave") {
          selectedValue.value = Get.arguments['leaveTypeId'];
        } else {
          // ignore: invalid_use_of_protected_member
          // selectedValue.value = dropdownItems.value[0].id!;
        }
        isLoading.value = false;

        // Data is loaded
      } else {
        DialogUtils().errorSnackBar("Failed to load data from API");
      }
    } catch (e) {
      DialogUtils().errorSnackBar("Something went wrong");
    }
  }

  String extractErrorMessages(Map<String, dynamic> responseBody) {
    if (responseBody['errors'] != null) {
      final errors = responseBody['errors'] as Map<String, dynamic>;
      StringBuffer errorMessage = StringBuffer();

      errors.forEach((key, value) {
        if (value is List) {
          for (var error in value) {
            errorMessage.writeln('$error');
          }
        }
      });

      return errorMessage.toString();
    }

    return responseBody['message'] ?? 'Something went wrong.';
  }

// Api Methods
  Future<void> uploadFile() async {
    try {
      if (selectedFile.value == null) return; // Ensure a file is selected
      isUploading.value = true; // Mark upload as in progress
      Response response = await addLeaveRepo!.applyLeaveWithFile(
        selectedFile.value!,
      );

      isUploading.value = false; // Reset upload status

      if (response.statusCode == 200) {
        // Get.snackbar("Success", "File uploaded successfully!");
        attachment.value = response.body["temp_file"];
        // DialogUtils().sucessSnackBar(response.body["message"]);
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  Future<void> leavesDaysCounts() async {
    final Map<String, dynamic> days = <String, dynamic>{
      "from_date": fromDateController.text,
      "to_date": toDateController.text
    };

    try {
      Response response = await addLeaveRepo!.daysCount(days);
      if (response.statusCode == 200) {
        LeaveDaysCount leavesDaysCounts =
            LeaveDaysCount.fromJson(response.body);
        leaveDaysCount.value = leavesDaysCounts.data!.days;
      } else {
        // Handle and show errors from the API response
        String errorMessage = extractErrorMessages(response.body);
        DialogUtils().errorSnackBar(errorMessage);
      }
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to load data.");
    }
  }

  Future<void> applyLeaveMethod() async {
    try {
      final Map<String, dynamic> applyLeaveBody = <String, dynamic>{
        "leave_type_id": selectedValue.value,
        "from_date": fromDateController.text,
        "reason": reasonController.text,
        if (attachment.value.isNotEmpty) "attachment": attachment.value,
        if (isHalfDay.value) ...{
          "is_half_day": isHalfDay.value,
          "first_half":
              // ignore: unrelated_type_equality_checks
              selectedLeaveType == LeaveTypeEnum.firstHalf ? true : false,
        } else
          "to_date": toDateController.text,
      };

      // print(applyLeaveBody);
      DialogUtils.showLoading(title: "");
      Response response = await addLeaveRepo!.applyLeave(applyLeaveBody);
      DialogUtils.closeLoading();
      if (response.statusCode == 201) {
        attachment.value = "";
        Get.toNamed(AppRoutes.leaveHistory);
        DialogUtils().sucessSnackBar(response.body["message"]);
        Get.find<LeaveController>().getAllLeaveMethod(null);
      }

      if (response.statusCode == 400) {
        DialogUtils().errorSnackBar(response.body["message"]);
      }

      if (response.statusCode == 422) {
        DialogUtils().errorSnackBar(response.body["errors"]["to_date"][0]);
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  Future<void> updateLeaveMethod() async {
    try {
      final Map<String, dynamic> updateLeaveBody = <String, dynamic>{
        "leave_type_id": selectedValue.value,
        "from_date": fromDateController.text,
        "reason": reasonController.text,
        if (isHalfDay.value) ...{
          "is_half_day": isHalfDay.value,
          "first_half":
              // ignore: unrelated_type_equality_checks
              selectedLeaveType == LeaveTypeEnum.firstHalf ? true : false,
        } else ...{
          "is_half_day": false,
          "first_half": false,
          "to_date": toDateController.text,
        }
      };

      DialogUtils.showLoading(title: "");
      Response response =
          await addLeaveRepo!.updateLeave(updateId.value, updateLeaveBody);
      DialogUtils.closeLoading();
      if (response.statusCode == 200) {
        Get.back();
        DialogUtils().sucessSnackBar(response.body["message"]);
        Get.find<LeaveController>().getAllLeaveMethod(null);
      }
      if (response.statusCode == 400) {
        DialogUtils().errorSnackBar(response.body["message"]);
      }
      if (response.statusCode == 422) {
        DialogUtils().errorSnackBar(response.body["errors"]["to_date"][0]);
      }
    } catch (e) {
      DialogUtils().errorSnackBar(e);
    }
  }

  void _onSelectionChange(
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    // print(dateRangePickerSelectionChangedArgs);
  }
}
