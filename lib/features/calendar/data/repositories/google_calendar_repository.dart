import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';

class GoogleCalendarRepository implements CalendarRepository {
  final GoogleSignIn _googleSignIn;

  GoogleCalendarRepository(this._googleSignIn);

  @override
  Future<List<CalendarEvent>> fetchTodayEvents() async {
    final client = await _googleSignIn.authenticatedClient();
    if (client == null) {
      throw Exception('Failed to get authenticated Google API client. Please ensure you are signed in and granted Calendar permissions.');
    }

    final calendarApi = calendar.CalendarApi(client);
    
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    try {
      final events = await calendarApi.events.list(
        'primary',
        timeMin: startOfDay.toUtc(),
        timeMax: endOfDay.toUtc(),
        singleEvents: true,
        orderBy: 'startTime',
      );

      if (events.items == null) return [];

      return events.items!.map((event) {
        final start = event.start?.dateTime ?? event.start?.date;
        final end = event.end?.dateTime ?? event.end?.date;
        
        final isAllDay = event.start?.dateTime == null && event.start?.date != null;

        return CalendarEvent(
          eventId: event.id ?? 'unknown',
          title: event.summary ?? 'Busy',
          startTime: start?.toLocal() ?? DateTime.now(),
          endTime: end?.toLocal() ?? DateTime.now().add(const Duration(hours: 1)),
          isAllDay: isAllDay,
          description: event.description,
          location: event.location,
        );
      }).toList();
    } catch (e) {
      print('Error fetching Google Calendar events: $e');
      return [];
    }
  }
}
