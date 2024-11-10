import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/app_routes.dart';
import 'package:trealapp/core/utils/dialog_utils.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/core/widget/sized_box_hight.dart';
import 'package:trealapp/module/leaves/controller/leave_controller.dart';
import 'package:trealapp/module/leaves/model/leave_model.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class LeaveDetailsWidget extends StatefulWidget {
  final Leaves leave;
  final String Function(String?) formatDate;
  final VoidCallback onDelete; // Add this callback for the delete action
  final LeaveController leaveController;

  const LeaveDetailsWidget(
      {super.key,
      required this.leave,
      required this.formatDate,
      required this.onDelete,
      required this.leaveController});

  @override
  // ignore: library_private_types_in_public_api
  _LeaveDetailsWidgetState createState() => _LeaveDetailsWidgetState();
}

// Future<void> downloadFile(attachmentUrl) async {
//   try {
//     await FlutterDownloader.enqueue(
//       url: attachmentUrl,
//       savedDir: 'the path of directory where you want to save downloaded files',
//       showNotification:
//           true, // show download progress in status bar (for Android)
//       openFileFromNotification:
//           true, // click on notification to open downloaded file (for Android)
//     );
//   } on PlatformException catch (e) {
//     DialogUtils().errorSnackBar('Error Platform exception: ${e.message}');
//   } catch (e) {
//     DialogUtils().errorSnackBar('Error Something went wrong: $e');
//   }
// }

class _LeaveDetailsWidgetState extends State<LeaveDetailsWidget> {
  bool isExpanded = false;
  bool isOverflowing = false; // Track if the text overflows
  String rejectionNote = '';
  var dio = Dio();
  @override
  void initState() {
    super.initState();
    // Initialize rejectionNote if there's a non-empty note in the leave history
    for (var leaveApprover in widget.leave.history ?? []) {
      if (leaveApprover.note != null && leaveApprover.note!.isNotEmpty) {
        rejectionNote = leaveApprover.note!;
        break;
      }
    }
  }

  Future<void> downloadFile(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      // print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      widget.leaveController.downloadProcess.value =
          (received / total * 100).toStringAsFixed(0) + "%";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReasonText(),
        const SizedBoxHight(hieght: 5),
        // _buildDetailsRow(),
      ],
    );
  }

  Widget _buildReasonText() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure if text overflows
        final textSpan = TextSpan(
          text: widget.leave.reason ?? "N/A",
          style: TextStyles.title18.copyWith(color: grayColor),
        );

        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        isOverflowing = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the reason text with Show More/Less functionality
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // widget.leave.reason ?? "N/A"
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Dimensions.widthScreen60,
                          child: Text(
                            widget.leave.reason ?? "N/A",
                            style:
                                TextStyles.title18.copyWith(color: grayColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_double_arrow_down_rounded,
                          size: 20,
                          color: blueColor,
                        )
                      ],
                    ),
                    const SizedBoxHight(
                      hieght: 10,
                    ),
                    _buildDetailsColumn(),
                    const SizedBoxHight(
                      hieght: 10,
                    ),
                  ],
                ),
              ),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.leave.reason ?? "N/A",
                              style: TextStyles.regular16,
                            ),
                            const SizedBoxHight(hieght: 15),
                            _buildContainer(
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildApprovalHeading(),
                                  _buildApprovalList(), // Show ListView in expanded state
                                  const SizedBoxHight(
                                    hieght: 8,
                                  ),
                                  _buildDetailsColumn(),
                                ],
                              ),
                            ),
                            if (widget.leave.status == "0")
                              const SizedBoxHight(hieght: 10),
                            if (widget.leave.status == "0")
                              _buildContainer(_rejectionNote()),
                          ])),
                  const SizedBoxHight(hieght: 10),
                  if (widget.leave.attachment != null) _buildAttachmentView(),
                  if (widget.leave.attachment != null)
                    const SizedBoxHight(hieght: 10),
                  if (widget.leave.history!.isEmpty &&
                      widget.leave.status == "2")
                    _buildButtonGroup(),
                  if (widget.leave.history!.isEmpty &&
                      widget.leave.status == "2")
                    const SizedBoxHight(hieght: 10),
                ],
              ),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            const SizedBoxHight(hieght: 5),
            // Show the Show More / Less button only if text overflows
            // if (isOverflowing)
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Text(
                isExpanded ? "Show Less" : "Show More",
                style: TextStyles.regular12.copyWith(
                  color: blueColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildApprovalHeading() {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color.fromARGB(255, 219, 219, 219), width: 1))),
      child: Text(
        "Approver Details",
        style: TextStyles.title16.copyWith(color: blueColor),
      ),
    );
  }

  // Demo ListView showing approval data
  Widget _buildApprovalList() {
    if (widget.leave.history!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Center(
          child: Text(
            "No approval record found!",
            style: TextStyles.regular14.copyWith(color: lightGrayColor2),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.leave.history!.length,
      shrinkWrap: true, // Ensure it doesn't take full height
      physics: const NeverScrollableScrollPhysics(), // Prevent inner scrolling
      itemBuilder: (context, index) {
        var leaveApprover = widget.leave.history?[index];

        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 8 : 0, bottom: 8.0),
          child: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(255, 219, 219, 219), width: 1))),
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    // color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leaveApprover?.approved == "1"
                              ? "Approved By"
                              : "Reject by",
                          style: TextStyles.title14,
                        ),
                        const SizedBoxHight(
                          hieght: 8,
                        ),
                        Text(
                          "${leaveApprover?.approverFirstName}  ${leaveApprover?.approverLastName}",
                          style: TextStyles.regular14,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    // color: Colors.green,
                    padding: const EdgeInsets.only(
                        left: 8, top: 10, bottom: 10, right: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Department",
                          style: TextStyles.title14,
                        ),
                        const SizedBoxHight(
                          hieght: 8,
                        ),
                        Text(
                          leaveApprover?.approverDepartment ?? "N/A",
                          style: TextStyles.regular14,
                        )
                      ],
                    ),
                  ),
                ),
                // Text(
                //   approvalNames[index],
                //   style: TextStyles.regular14,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isExpanded)
          Text(
            "Leave Date",
            style: TextStyles.title14,
          ),
        const SizedBoxHight(
          hieght: 8,
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 1)),
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 8, vertical: 8),
              child: Text(
                widget.formatDate(widget.leave.fromDate),
                style:
                    TextStyles.regular10.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Text("-"),
            const SizedBox(
              width: 5,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color.fromARGB(255, 219, 219, 219),
                      width: 1)),
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 8, vertical: 8),
              child: Text(
                widget.formatDate(widget.leave.toDate),
                style:
                    TextStyles.regular10.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color.fromARGB(255, 219, 219, 219),
                        width: 1)),
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 8, vertical: 8),
                child: Text(
                  widget.leave.isHalfDay == "1"
                      ? widget.leave.firstHalf == "1"
                          ? "1st Half"
                          : "2nd Half"
                      : widget.leave.days == "1"
                          ? "${widget.leave.days ?? "N/A"} (Day)"
                          : "${widget.leave.days ?? "N/A"} (Days)",
                  style: TextStyles.regular10
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _rejectionNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              color: redColor,
              size: 16,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Rejection Acknowledgment",
              style: TextStyles.title14,
            ),

            // rejectionNote
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          rejectionNote,
          style: TextStyles.regular14,
        )
      ],
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color.fromARGB(255, 219, 219, 219), width: 1)),
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 15),
      child: child,
    );
  }

  Widget _buildAttachmentView() {
    final fileName = Uri.parse(widget.leave.attachment).pathSegments.last;
    String extractFileName(String url) {
      return url.split('/').last;
    }

    String extractFileExtension(String url) {
      // Extract the last segment after the last '.'
      return url.split('.').last;
    }

    bool isImageFile(String url) {
      String extension = extractFileExtension(url).toLowerCase();
      return extension == "jpg" || extension == "png" || extension == "jpeg";
    }

    Future<bool> checkIfFileExists(String fileName) async {
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        final downloadPath = path.join(
          directory.parent.parent.parent.parent.path,
          'Download',
        );
        String fullPath = path.join(downloadPath, fileName);

        // Check if the file exists
        File file = File(fullPath);
        return await file.exists();
      }
      return false;
    }

    return _buildContainer(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isImageFile(widget.leave.attachment)
                  ? Icons.image
                  : Icons.picture_as_pdf_outlined,
              color: blueColor,
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 120,
              child: Text(
                extractFileName(widget.leave.attachment),
                maxLines: 1,
                style: TextStyles.regular14,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
        GestureDetector(
          onTap: () async {
            if (isImageFile(widget.leave.attachment)) {
              openImageModal(widget.leave.attachment);
            } else {
              Directory? directory = await getExternalStorageDirectory();
              if (directory != null) {
                final downloadPath = path.join(
                  directory.parent.parent.parent.parent.path,
                  'Download',
                );
                // final fileName =
                //     Uri.parse(widget.leave.attachment).pathSegments.last;
                bool fileExists = await checkIfFileExists(fileName);
                String fullPath = path.join(downloadPath, fileName);

                if (fileExists) {
                  await OpenFilex.open(fullPath);
                } else {
                  await downloadFile(dio, widget.leave.attachment, fullPath);
                  await OpenFilex.open(fullPath);
                }
              }
            }
          },
          child: FutureBuilder<bool>(
              future: checkIfFileExists(fileName),
              builder: (context, snapshot) {
                bool fileExists = snapshot.data ?? false;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() {
                      String downloadProcess =
                          widget.leaveController.downloadProcess.value;
                      return Text(
                        isImageFile(widget.leave.attachment)
                            ? "View"
                            : downloadProcess == "100%" || fileExists
                                ? "Open"
                                : downloadProcess,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      );
                    }),
                    Obx(
                      () {
                        String downloadProcess =
                            widget.leaveController.downloadProcess.value;
                        return Icon(
                          isImageFile(widget.leave.attachment)
                              ? Icons.arrow_forward_ios_outlined
                              : downloadProcess == "100%" || fileExists
                                  ? Icons.check
                                  : Icons.download_outlined,
                          color: Colors.blue,
                          size: 18,
                        );
                      },
                    ),
                  ],
                );
              }),
        ),
      ],
    ));
  }

// Image Modal

  void openImageModal(String attachmentUrl) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(
          child: Image.network(
            attachmentUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) =>
                const Center(child: Text('Failed to load image')),
          ),
        ),
      ),
    );
  }

  // action button group
  Widget _buildButtonGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            DialogUtils().showDeleteConfirmationDialog(
              title: "Delete Item",
              content: "Are you sure you want to delete this item?",
              onConfirm: () {
                widget
                    .onDelete(); // Trigger the fade-out animation and deletion
                setState(() {
                  isExpanded = !isExpanded;
                });
                Get.back();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: redColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            minimumSize: const Size(50, 40),
          ),
          child: Text(
            "Delete",
            style: TextStyles.regular14.copyWith(color: whiteColor),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
            onPressed: () {
              Get.toNamed(
                AppRoutes.updateLeavesScreen,
                arguments: {
                  "leaveTypeId": widget.leave.leaveTypeId,
                  "fromDate": widget.leave.fromDate,
                  "toDate": widget.leave.toDate,
                  "reason": widget.leave.reason,
                  "isHalfDay": widget.leave.isHalfDay,
                  "firstHalf": widget.leave.firstHalf,
                  "leaveId": widget.leave.id,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cyanColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: const Size(50, 40),
            ),
            child: Text(
              "Update",
              style: TextStyles.regular14.copyWith(color: whiteColor),
            ))
      ],
    );
  }
}
