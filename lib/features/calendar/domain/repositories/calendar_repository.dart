import '../entities/calendar_event.dart';

abstract class CalendarRepository {
  /// Fetches events for the current day from the calendar
  Future<List<CalendarEvent>> fetchTodayEvents();
}
