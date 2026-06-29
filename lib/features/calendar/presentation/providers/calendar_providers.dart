import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/google_calendar_repository.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';

// Provides the GoogleSignIn instance configured with Calendar scopes.
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: [
      calendar.CalendarApi.calendarReadonlyScope,
    ],
  );
});

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final googleSignIn = ref.watch(googleSignInProvider);
  return GoogleCalendarRepository(googleSignIn);
});

final todayCalendarEventsProvider = FutureProvider.autoDispose<List<CalendarEvent>>((ref) async {
  // Ensure user is signed in first
  final authState = ref.watch(authStateProvider);
  if (authState.value == null) {
    return [];
  }
  
  final repository = ref.watch(calendarRepositoryProvider);
  return repository.fetchTodayEvents();
});
