import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/module/leaves/model/leave_approval_model.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/module/leaves/repo/leave_approval_repo.dart';
import 'package:trealapp/module/leaves/view/approver/widget/approval_leave_request_item.dart';

class LeaveApprovalController extends GetxController
    with GetSingleTickerProviderStateMixin {
  LeaveApprovalRepo? leaveApprovalRepo;

  LeaveApprovalController({this.leaveApprovalRepo}) {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        // Detect swipe
        setTabAndFetch(tabController.index);
      }
    });
  }

  final RxString page = "1".obs;
  final RxString startDate = "".obs;
  final RxString endDate = "".obs;
  final RxString perPage = "35".obs;
  var currentDate = DateTime.now().obs;

  var isLoading = true.obs;

  final RxString leaveStatus = "all".obs;
  RxInt currentTabIndex = 0.obs;
  late TabController tabController;
  RxBool searchToggle = false.obs;
  RxDouble expandedHeight = 50.0.obs;
  RxString downloadProcess = "Download".obs;

  var leaveApprovalRequestData = <Datum>[].obs;

  // text controller
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getAllLeaveApprovalRequestMethod();
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

  Future<void> refreshgetAllApproverLeaveMethod() async {
    switch (currentTabIndex.value) {
      case 0:
        leaveStatus.value = "pending";
        leaveApprovalRequestData.value = [];
        getAllLeaveApprovalRequestMethod();
        break;
      case 1:
        leaveStatus.value = "all";
        leaveApprovalRequestData.value = [];
        getApproverAllLeaveApprovalRequestMethod(null);
        break;
      case 2:
        leaveStatus.value = "accepted";
        leaveApprovalRequestData.value = [];
        getApproverAllLeaveApprovalRequestMethod(1);
        break;
      case 3:
        leaveStatus.value = "rejected";
        leaveApprovalRequestData.value = [];
        getApproverAllLeaveApprovalRequestMethod(0);
        break;
    }
  }

  void setTabAndFetch(int index) {
    currentTabIndex.value = index;
    switch (index) {
      case 0:
        leaveStatus.value = "pending";
        leaveApprovalRequestData.value = [];
        getAllLeaveApprovalRequestMethod();
        break;
      case 1:
        leaveStatus.value = "all";
        leaveApprovalRequestData.value = [];
        getApproverAllLeaveApprovalRequestMethod(null);
        break;
      case 2:
        leaveStatus.value = "accepted";
        leaveApprovalRequestData.value = [];
        getApproverAllLeaveApprovalRequestMethod(1);
        break;
      case 3:
        leaveStatus.value = "rejected";
        leaveApprovalRequestData.value = [];
        getApproverAllLeaveApprovalRequestMethod(0);
        break;
    }
  }

  void getFistLastDateOfMonth() {
    DateTime date = DateTime.now();
// Get the first date of the current month
    DateTime firstDateOfMonth = DateTime(date.year, date.month, 1);
    String formattedFirstDateOfMonth =
        DateFormat('yyyy-MM-dd').format(firstDateOfMonth);

// Get the last date of the current month
    DateTime lastDateOfMonth = DateTime(date.year, date.month + 1, 0);
    String formattedLastDateOfMonth =
        DateFormat('yyyy-MM-dd').format(lastDateOfMonth);
    startDate.value = formattedFirstDateOfMonth.toString();
    endDate.value = formattedLastDateOfMonth.toString();
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
    setTabAndFetch(currentTabIndex.value);
  }

  // Go to the next month
  void nextYear() async {
    currentDate.value = DateTime(currentDate.value.year + 1);
    getFistLastDateOfYear(currentDate.value);
    setTabAndFetch(currentTabIndex.value);
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
    setTabAndFetch(currentTabIndex.value);
    fromDateController.clear();
    toDateController.clear();
  }

  // Method to remove from the pending tab
  void removeFromPendindTabApproveLeave(BuildContext context, int index, int id,
      int approve, String? note) async {
    // Call your API or repository method here
    try {
      await postLeaveApprove(id, approve, note);
      // print(note);
      // If successful, remove the item from AnimatedList and the local list
      // ignore: use_build_context_synchronously
      AnimatedList.of(context).removeItem(
        index,
        (context, animation) => FadeTransition(
          opacity: animation,
          child: ApprovalLeaveRequestItem(
            leave: leaveApprovalRequestData[index],
            index: index,
            leavesLastIndex: leaveApprovalRequestData.length - 1,
            leaveController: this,
            onApprove: () {},
          ),
        ),
        duration: const Duration(milliseconds: 500),
      );

      leaveApprovalRequestData.removeAt(index);
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to approve leave.");
    }
  }

//  Methods
  Future<void> getAllLeaveApprovalRequestMethod() async {
    try {
      isLoading(true);
      Response response = await leaveApprovalRepo!.getAllLeaveApprovalRequest();
      if (response.statusCode == 200) {
        LeaveApprovalModel leaveApprovalModel =
            LeaveApprovalModel.fromJson(response.body);
        leaveApprovalRequestData.value = leaveApprovalModel.data!;
        isLoading(false);
      } else {
        DialogUtils().errorSnackBar("Failed to load data from API");
      }
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to get Leave: $e");
    }
  }

  //  Methods
  Future<void> getApproverAllLeaveApprovalRequestMethod(int? approved) async {
    try {
      isLoading(true);
      Response response =
          await leaveApprovalRepo!.getApproverAllLeaveApprovalRequest(approved);
      if (response.statusCode == 200) {
        LeaveApprovalModel leaveApprovalModel =
            LeaveApprovalModel.fromJson(response.body);
        leaveApprovalRequestData.value = leaveApprovalModel.data!;
        isLoading(false);
      } else {
        DialogUtils().errorSnackBar("Failed to load data from API");
      }
    } catch (e) {
      DialogUtils().errorSnackBar("Failed to get Leave: $e");
    }
  }

  Future<void> postLeaveApprove(int id, int approve, String? note) async {
    try {
      Map<String, dynamic> data = {
        "approve": approve,
        if (note != null) "note": note
      };

      Response response = await leaveApprovalRepo!.postleaveApprove(id, data);

      if (response.statusCode == 200) {
        DialogUtils().sucessSnackBar("${response.body["message"]}");
      } else {
        throw Exception("");
      }
    } catch (e) {
      // Throw the error to be handled in the calling method
      throw Exception("$e");
    }
  }
}
