import 'package:intl/intl.dart';

class AddToCalendar {
  AddToCalendar._privateConstructor();
  static final AddToCalendar _instance = AddToCalendar._privateConstructor();
  factory AddToCalendar() {
    return _instance;
  }

  // Convert to YYYYMMDDTHHMMSSZ
  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'');
    return formatter.format(dateTime.toUtc());
  }

  // GOOGLE CALENDAR
  String getGoogleCalendarUrl({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
  }) {
    // final String startDate = startTime.toString();
    // final String endDate = endTime.toString();

    final String encodedTitle = Uri.encodeComponent(title);
    final String encodedDescription = Uri.encodeComponent(description);

    final String url = 'https://calendar.google.com/calendar/event'
        '?action=TEMPLATE'
        '&text=$encodedTitle'
        '&details=$encodedDescription'
        '&dates=$startTime/$endTime';

    return url;
  }

  // APPLE CALENDAR
  String getAppleCalendarUrl({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
  }) {
    // final String startDate = startTime.toString();
    // final String endDate = endTime.toString();

    final String encodedTitle = Uri.encodeComponent(title);
    final String encodedDescription = Uri.encodeComponent(description);

    final String url = 'webcal://p33-caldav.icloud.com/published/2/CALENDAR_ID/events/event.ics'
        '?title=$encodedTitle'
        '&description=$encodedDescription'
        '&startDate=$startTime'
        '&endDate=$endTime';

    return url;
  }
}


// 2022-01-27T10:30:00.030+0100
// YYYYMMDDTHHMMSSZ