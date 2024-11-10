import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/leaves/controller/add_leave_controller.dart';
import 'package:trealapp/module/leaves/view/add_leaves_screen.dart';
import 'package:trealapp/module/leaves/view/widget/leave_type_skeleton_loader.dart';

class UpdateLeavesScreen extends StatelessWidget {
  UpdateLeavesScreen({super.key});

  final AddLeaveController addLeaveController = Get.find<AddLeaveController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Fetch arguments from the previous screen
    _populateInitialValues();

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(
          right: 15.0,
          left: 15.0,
          top: 15.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: _buildLeaveForm(context), // Show the form
          ),
        ),
      ),
    );
  }

  /// Populates initial values from arguments
  void _populateInitialValues() {
    final args = Get.arguments ?? {};
    // addLeaveController.selectedValue.value = args['leaveTypeId'] ?? 0;
    addLeaveController.fromDateController.text = args['fromDate'] ?? "";
    addLeaveController.toDateController.text = args['toDate'] ?? "";
    addLeaveController.reasonController.text = args['reason'] ?? "";
    addLeaveController.isHalfDay.value =
        args['isHalfDay'] == "1" ? true : false;
    args['isHalfDay'] == "1"
        ? addLeaveController.selectedLeaveType.value = args["firstHalf"] == "1"
            ? LeaveTypeEnum.firstHalf
            : LeaveTypeEnum.secondHalf
        : null;
    addLeaveController.updateId.value = args['leaveId'];
  }

  /// Builds the AppBar
  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Update your Leave", style: TextStyles.title16),
      shadowColor: Colors.black26,
      backgroundColor: Colors.white,
    );
  }

  /// Builds the complete leave form
  Widget _buildLeaveForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBoxHight(hieght: 10),
        Obx(() => addLeaveController.isLoading.value
            ? const LeaveTypeSkeletonLoader()
            : _buildLeaveTypeDropdown()),
        const SizedBoxHight(hieght: 20),
        _buildHalfDayDropdown(),
        const SizedBoxHight(hieght: 20),
        _buildDateField(
            context,
            "Start Date",
            addLeaveController.fromDateController,
            addLeaveController.datePicker),
        Obx(() => AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: addLeaveController.isHalfDay.value
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        const SizedBoxHight(hieght: 20),
                        _buildDateField(
                            context,
                            "End Date",
                            addLeaveController.toDateController,
                            addLeaveController.datePicker),
                        const SizedBoxHight(hieght: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Requested Days: ",
                              style: TextStyles.regular12
                                  .copyWith(color: lightGrayColor2),
                            ),
                            Obx(() => Text(
                                  addLeaveController.leaveDaysCount.value,
                                  style: TextStyles.regular12
                                      .copyWith(color: lightGrayColor2),
                                ))
                          ],
                        )
                      ],
                    ),
            )),
        const SizedBoxHight(hieght: 20),
        _buildReasonField(),
        const SizedBoxHight(hieght: 20),
        _buildFileUploadField(),
        const SizedBoxHight(hieght: 20),
        _buildSubmitButton(),
        const SizedBoxHight(hieght: 20),
      ],
    );
  }

  /// Builds the dropdown for selecting leave type.
  Widget _buildLeaveTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Select a Leave type",
              style: TextStyles.regular14.copyWith(
                color: lightGrayColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              " *",
              style: TextStyle(color: redColor),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() => DropdownButtonFormField<int>(
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down),
              decoration: _inputDecoration(),
              value: addLeaveController.selectedValue.value != 0
                  ? addLeaveController.selectedValue.value
                  : null,
              items: _buildDropdownItems(),
              onChanged: (newValue) {
                addLeaveController.selectedValue.value = newValue!;
              },
            )),
      ],
    );
  }

  /// Builds the list of dropdown items for leave types.
  List<DropdownMenuItem<int>> _buildDropdownItems() {
    return addLeaveController.dropdownItems.map((item) {
      return DropdownMenuItem<int>(
        value: item.id,
        child: Text(item.leaveTypeName ?? '', style: TextStyles.regular16),
      );
    }).toList();
  }

  /// Builds the dropdown for Half/Full day leave
  Widget _buildHalfDayDropdown() {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select leave schedule",
          style: TextStyles.regular14.copyWith(
            color: lightGrayColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(34, 169, 168, 168),
            ),
            child: DropdownButton<LeaveTypeEnum>(
              isExpanded: true,
              value: addLeaveController.selectedLeaveType.value,
              padding: const EdgeInsets.only(top: 3, bottom: 3),
              items: [
                DropdownMenuItem(
                  value: LeaveTypeEnum.fullDay,
                  child: Text("Full Day", style: TextStyles.regular16),
                ),
                DropdownMenuItem(
                  value: LeaveTypeEnum.firstHalf,
                  child: Text("First Half Day", style: TextStyles.regular16),
                ),
                DropdownMenuItem(
                  value: LeaveTypeEnum.secondHalf,
                  child: Text("Second Half Day", style: TextStyles.regular16),
                ),
              ],
              onChanged: (LeaveTypeEnum? newValue) {
                if (newValue != null) {
                  if (newValue == LeaveTypeEnum.firstHalf ||
                      newValue == LeaveTypeEnum.secondHalf) {
                    addLeaveController.isHalfDay.value = true;
                  } else {
                    addLeaveController.isHalfDay.value = false;
                  }
                  addLeaveController.selectedLeaveType.value = newValue;
                }
              },
              underline: const SizedBox(), // Removes default underline
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a reusable date field
  Widget _buildDateField(BuildContext context, String label,
      TextEditingController controller, onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyles.regular14.copyWith(
                color: grayColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              " *",
              style: TextStyle(color: redColor),
            ),
          ],
        ),
        const SizedBoxHight(),
        TextFormField(
          controller: controller,
          onTap: () {
            onTap(context, label);
          },
          readOnly: true,
          decoration: _inputDecoration(
            suffixIcon: const Icon(Icons.calendar_month_outlined),
          ),
        ),
      ],
    );
  }

  /// Builds the reason field
  Widget _buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Reason for leave",
              style: TextStyles.regular14.copyWith(
                color: grayColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              " *",
              style: TextStyle(color: redColor),
            ),
          ],
        ),
        const SizedBoxHight(),
        TextFormField(
          controller: addLeaveController.reasonController,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          decoration: _inputDecoration(
            hintText: "Please write down your reason",
            hintStyle: const TextStyle(color: lightGrayColor2),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return "Please enter Your Reason";
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Builds the file upload input field.
  Widget _buildFileUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upload Attachment",
          style: TextStyles.regular14.copyWith(
            color: lightGrayColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Obx(() {
          final file = addLeaveController.selectedFile.value;
          final isUploading = addLeaveController.isUploading.value;

          // Helper function to check if the file is an image
          bool isImage(File? file) {
            if (file == null) return false;
            final extension = file.path.split('.').last.toLowerCase();
            return ['jpg', 'jpeg', 'png', 'gif'].contains(extension);
          }

          return GestureDetector(
            onTap: () async {
              if (!isUploading) {
                await _showFilePickerDialog();
              }
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(34, 169, 168, 168),
                image: isImage(file)
                    ? DecorationImage(
                        image: FileImage(file!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isUploading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          file == null
                              ? Icons.add
                              : isImage(file)
                                  ? Icons.add
                                  : Icons.file_present_outlined,
                          size: 38,
                          color: file == null
                              ? lightGrayColor2
                              : isImage(file)
                                  ? whiteColor
                                  : lightGrayColor2,
                        ),
                        Text(
                          file == null
                              ? "Add File"
                              : isImage(file)
                                  ? "Add File"
                                  : file.path.split('/').last,
                          style: TextStyles.regular16.copyWith(
                            color: file == null
                                ? grayColor
                                : isImage(file)
                                    ? whiteColor
                                    : grayColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),
          );
        }),
      ],
    );
  }

  /// File picker dialog for choosing image or PDF.
  Future<void> _showFilePickerDialog() async {
    Get.bottomSheet(
      Material(
          color: Colors.transparent,
          child: Container(
              height: Dimensions.height160,
              padding: EdgeInsets.all(Dimensions.padding20),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(Dimensions.radius20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Choose One",
                    style: TextStyles.title18,
                  ),
                  const SizedBoxHight(
                    hieght: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Get.back();
                          await addLeaveController
                              .pickImage(ImageSource.gallery);
                        },
                        child: Column(
                          children: [
                            const Icon(
                              Icons.image,
                              size: 50,
                              color: cyanColor,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyles.title14,
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Get.back();
                          await addLeaveController
                              .pickImage(ImageSource.camera);
                        },
                        child: Column(
                          children: [
                            const Icon(
                              Icons.camera,
                              size: 50,
                              color: blueColor,
                            ),
                            Text(
                              "Camera",
                              style: TextStyles.title14,
                            )
                          ],
                        ),
                      ),

                      // GestureDetector(
                      //   onTap: () async {
                      //     Get.back();
                      //     await addLeaveController.pickPdf();
                      //   },
                      //   child: Column(
                      //     children: [
                      //       const Icon(
                      //         Icons.folder,
                      //         size: 50,
                      //         color: lightGrayColor2,
                      //       ),
                      //       Text(
                      //         "File",
                      //         style: TextStyles.title14,
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ],
              ))),
    );
    //   Get.defaultDialog(
    //     title: "Choose File",
    //     content: Column(
    //       children: [
    //         ListTile(
    //           leading: const Icon(Icons.image),
    //           title: const Text("Pick from Gallery"),
    //           onTap: () async {
    //             Get.back();
    //             await addLeaveController.pickImage(ImageSource.gallery);
    //           },
    //         ),
    //         ListTile(
    //           leading: const Icon(Icons.camera),
    //           title: const Text("Pick from Camera"),
    //           onTap: () async {
    //             Get.back();
    //             await addLeaveController.pickImage(ImageSource.camera);
    //           },
    //         ),
    //         ListTile(
    //           leading: const Icon(Icons.picture_as_pdf),
    //           title: const Text("Pick PDF"),
    //           onTap: () async {
    //             Get.back();
    //             await addLeaveController.pickPdf();
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    //
  }

  /// Builds the submit button
  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            addLeaveController.updateLeaveMethod();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          minimumSize: const Size(double.infinity, 40),
        ),
        child: Text(
          "Update".toUpperCase(),
          style: TextStyles.regular16.copyWith(color: whiteColor),
        ),
      ),
    );
  }

  /// Builds the input decoration used across text fields.
  InputDecoration _inputDecoration(
      {Widget? suffixIcon, String? hintText, TextStyle? hintStyle}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color.fromARGB(34, 169, 168, 168),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: hintStyle,
    );
  }
}
