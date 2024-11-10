import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/leaves/model/leave_model.dart';
import 'package:trealapp/module/leaves/repo/add_leave_repo.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/module/leaves/view/widget/leave_history_item.dart';

class LeaveController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AddLeaveRepo? addLeaveRepo;

  LeaveController({this.addLeaveRepo}) {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        // Detect swipe
        setTabAndFetch(tabController.index);
      }
    });
  }

// Pagination
  final RxString page = "1".obs;
  final RxString startDate = "".obs;
  final RxString endDate = "".obs;
  final RxString perPage = "35".obs;
  var currentDate = DateTime.now().obs;

// Leaves Data
  var leaveSummary = <LeaveTypeSummary>[].obs;
  var leaveHistory = <Leaves>[].obs;
  var isLoading = true.obs;

// Leave status value
  final RxString leaveStatus = "all".obs;
  RxInt currentTabIndex = 0.obs;
  late TabController tabController;
  RxBool searchToggle = false.obs;
  RxDouble expandedHeight = 50.0.obs;
  RxString downloadProcess = "Download".obs;

  // text controller
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getFistLastDateOfYear(currentDate.value);
    getAllLeaveMethod(null);
  }

  void toggleSearch() {
    searchToggle.value = !searchToggle.value;
    if (searchToggle.value) {
      expandedHeight.value = 90.0; // Start with expanded height
    } else {
      // Delay the reduction of expandedHeight by 300 milliseconds
      Future.delayed(const Duration(milliseconds: 300), () {
        expandedHeight.value = 50.0;
      });
    }
  }

  void switchCageOfLeaveMethod(int index) async {
    currentTabIndex.value = index;
    switch (index) {
      case 0:
        leaveStatus.value = "all";
        leaveSummary.value = [];
        leaveHistory.value = [];

        await getAllLeaveMethod(null);
        break;
      case 1:
        leaveStatus.value = "pending";
        leaveSummary.value = [];
        leaveHistory.value = [];
        await getAllLeaveMethod("2");
        break;
      case 2:
        leaveStatus.value = "accepted";
        leaveSummary.value = [];
        leaveHistory.value = [];

        await getAllLeaveMethod("1");
        break;
      case 3:
        leaveStatus.value = "rejected";
        leaveSummary.value = [];
        leaveHistory.value = [];
        await getAllLeaveMethod("0");
        break;
    }
  }

  Future<void> refreshgetAllLeaveMethod() async {
    getFistLastDateOfYear(currentDate.value);
    switchCageOfLeaveMethod(currentTabIndex.value);
  }

  void setTabAndFetch(int index) async {
    switchCageOfLeaveMethod(index);
  }

  void getFistLastDateOfYear(DateTime currentDate) {
    DateTime date = currentDate;
// Get the first date of the current month
    DateTime firstDateOfYear = DateTime(date.year, 1, 1);
    String formattedFirstDateOfMonth =
        DateFormat('yyyy-MM-dd').format(firstDateOfYear);

// Get the last date of the current month
    DateTime lastDateOfYear = DateTime(date.year, 12, 31);
    String formattedLastDateOfMonth =
        DateFormat('yyyy-MM-dd').format(lastDateOfYear);
    startDate.value = formattedFirstDateOfMonth.toString();
    endDate.value = formattedLastDateOfMonth.toString();
  }

  // Go to the previous month
  void previousYear() async {
    currentDate.value = DateTime(currentDate.value.year - 1);

    getFistLastDateOfYear(currentDate.value);
    switchCageOfLeaveMethod(currentTabIndex.value);
  }

  // Go to the next month
  void nextYear() async {
    currentDate.value = DateTime(currentDate.value.year + 1);
    getFistLastDateOfYear(currentDate.value);
    switchCageOfLeaveMethod(currentTabIndex.value);
  }

  void dateRangePicker() {
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
                        DateFormat('yyyy-MM-dd').format(startDate);
                    toDateController.text =
                        DateFormat('yyyy-MM-dd').format(endDate);
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

  void dateRangeSearch() async {
    startDate.value = fromDateController.text;
    endDate.value = toDateController.text;
    update();
    switchCageOfLeaveMethod(currentTabIndex.value);
    fromDateController.clear();
    toDateController.clear();
  }

//  Methods
  Future<void> getAllLeaveMethod(String? status) async {
    try {
      isLoading(true);
      Response response = await addLeaveRepo!.getAllLeave(
          page.value, perPage.value, startDate.value, endDate.value, status);
      if (response.statusCode == 200) {
        LeaveModel leaveModel = LeaveModel.fromJson(response.body);
        leaveSummary.value = leaveModel.leaveTypeSummary ?? [];
        leaveHistory.value = leaveModel.leaves ?? [];
        isLoading(false);
      } else {
        DialogUtils().errorSnackBar("Failed to load data from API");
      }
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to get Leave: $e");
    }
  }

  // Method to delete the leave
  void deleteLeave(
    BuildContext context,
    int index,
    int id,
    leave,
    leaveList,
  ) async {
    try {
      await deleteLeaveMethod(id);

      // ignore: use_build_context_synchronously
      AnimatedList.of(context).removeItem(
        index,
        (context, animation) => FadeTransition(
          opacity: animation,
          child: LeaveHistoryItem(
            leave: leave,
            index: index,
            leavesLastIndex: leaveList.length - 1,
            leaveController: this,
            onDelete: () {},
          ),
        ),
        duration: const Duration(milliseconds: 500),
      );

      // Remove the item with animation
      leaveHistory.removeAt(index);
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to approve leave.");
    }
  }

  Future<void> deleteLeaveMethod(num id) async {
    try {
      Response response = await addLeaveRepo!.deleteLeave(id);
      if (response.statusCode == 200) {
        DialogUtils().sucessSnackBar("${response.body["message"]}");
        // getAllLeaveMethod();
      } else {
        throw Exception("");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}
