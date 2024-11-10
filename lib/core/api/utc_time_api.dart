import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UtcTimeApi {
  Future<String> fetchAccurateTime() async {
    dynamic localTime;
    try {
      http.Response response =
          await http.get(Uri.parse('http://worldtimeapi.org/api/ip'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final DateTime utcTime = DateTime.parse(data['datetime']);
        final String utcOffset = data['utc_offset'];

        // Parse the offset string to a Duration
        final offsetDuration = _parseOffset(utcOffset);

        // Add the offset to the UTC time to get the local time
        localTime = utcTime.add(offsetDuration);
      }
      return DateFormat('MM/dd/yyyy hh:mm a').format(localTime);
    } catch (e) {
      throw Exception('$e');
    }
  }

  Duration _parseOffset(String offset) {
    // Parse the UTC offset string, e.g., "+06:00" or "-04:30"
    final sign = offset.startsWith('-') ? -1 : 1;
    final parts = offset.substring(1).split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);

    return Duration(hours: sign * hours, minutes: sign * minutes);
  }
}
