import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trealapp/core/colors/colors.dart'; // Define your custom colors here
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/core/utils/dimensions.dart';
import 'package:trealapp/module/calender/controller/calender_controller.dart';

class HolidayEmployeeScreen extends StatelessWidget {
  HolidayEmployeeScreen({super.key});
  final CalenderController holidayController = Get.find<CalenderController>();

  final EventController eventController = EventController();

  String formatDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat('EEE, yyyy-MM-dd').format(date);
  }

  void _addEvents() {
    final data = holidayController.data.value;
    if (data == null) return;
    String normalizeDate(String date) {
      // Ensure the date format is consistent as 'yyyy-MM-dd'
      List<String> parts = date.split('-');
      String year = parts[0];
      String month = parts[1].padLeft(2, '0'); // Ensure 2-digit month
      String day = parts[2].padLeft(2, '0'); // Ensure 2-digit day

      return '$year-$month-$day';
    }

    // Create weekend events
    final weekendEvents = data.weekends?.map((date) {
          return CalendarEventData(
            title: "Weekend",
            date: DateTime.parse(normalizeDate(date)),
            color: cyanColor,
            // eventColor: ,
          );
        }).toList() ??
        [];

    // Create holiday events
    final holidayEvents = data.holidays?.map((holiday) {
          return CalendarEventData(
            title: holiday.name ?? "Holiday",
            date: DateTime.parse(normalizeDate(holiday.startDate!)),
            endDate: DateTime.parse(normalizeDate(holiday.endDate!)),
            color: blueColor,
          );
        }).toList() ??
        [];

    // Create leave events
    final leaveEvents = data.leaves?.map((leave) {
          return CalendarEventData(
            title: "Leave - ${leave.reason ?? "N/A"}",
            date: DateTime.parse(normalizeDate(leave.fromDate!)),
            endDate: DateTime.parse(normalizeDate(leave.toDate!)),
            color: orangeColor,
          );
        }).toList() ??
        [];

    // Add all events to the EventController
    eventController
        .addAll([...weekendEvents, ...holidayEvents, ...leaveEvents]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (holidayController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = holidayController.data.value;

        if (data == null ||
            (data.holidays?.isEmpty ?? true) &&
                (data.leaves?.isEmpty ?? true) &&
                (data.weekends?.isEmpty ?? true)) {
          return const Center(child: Text("No holidays or leaves available"));
        }

        // Add events only once
        _addEvents();

        return MonthView(
          controller: eventController,
          onEventTap: (events, date) {
            final event = events; // Assuming single event per tap
            Get.defaultDialog(
              title: event.title,
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.padding15),
                child: Text(
                  "From ${formatDate(event.date)} to ${formatDate(event.endDate)}",
                  style: TextStyles.regular14
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              confirm: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(width: 1, color: redColor)),
                onPressed: () => Get.back(),
                child: Text(
                  "Close",
                  style: TextStyles.regular14
                      .copyWith(color: redColor, fontWeight: FontWeight.w600),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
