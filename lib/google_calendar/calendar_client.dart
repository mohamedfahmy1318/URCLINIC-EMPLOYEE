import 'package:googleapis/calendar/v3.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CalendarClient {
  static CalendarApi? calendar;

  Future<Map<String, String>> insert({
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    bool hasConferenceSupport = false,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    Map<String, String> eventData = {};

    const String calendarId = "primary";
    final Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    if (hasConferenceSupport) {
      final ConferenceData conferenceData = ConferenceData();
      final CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
      conferenceRequest.requestId = "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
      conferenceData.createRequest = conferenceRequest;

      event.conferenceData = conferenceData;
    }

    final EventDateTime start = EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    final EventDateTime end = EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    try {
      await calendar?.events.insert(event, calendarId, conferenceDataVersion: hasConferenceSupport ? 1 : 0, sendUpdates: shouldNotifyAttendees ? "all" : "none").then((value) {
        if (value.status == "confirmed") {
          toast(locale.value.eventAddedSuccessfully);

          if (hasConferenceSupport) {
            String eventId;
            eventId = value.id!;
            final String joiningLink = "https://meet.google.com/${value.conferenceData?.conferenceId}";
            eventData = {'id': eventId, 'link': joiningLink};
          } else {
            eventData = {"status": value.status.validate()};
          }
        } else {
          log("Unable to update event in google calendar");
        }
      });
    } catch (e) {
      toast(e.toString());
      log('Error creating event $e');
    }

    return eventData;
  }

  Future<Map<String, String>> modify({
    required String id,
    required String title,
    required String description,
    required String location,
    required List<EventAttendee> attendeeEmailList,
    required bool shouldNotifyAttendees,
    bool hasConferenceSupport = false,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    Map<String, String> eventData = {};

    const String calendarId = "primary";
    final Event event = Event();

    event.summary = title;
    event.description = description;
    event.attendees = attendeeEmailList;
    event.location = location;

    final EventDateTime start = EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+05:30";
    event.start = start;

    final EventDateTime end = EventDateTime();
    end.timeZone = "GMT+05:30";
    end.dateTime = endTime;
    event.end = end;

    try {
      await calendar?.events.patch(event, calendarId, id, conferenceDataVersion: hasConferenceSupport ? 1 : 0, sendUpdates: shouldNotifyAttendees ? "all" : "none").then((value) {
        if (value.status == "confirmed") {
          toast(locale.value.eventAddedSuccessfully);

          if (hasConferenceSupport) {
            String eventId;
            eventId = value.id!;
            final String joiningLink = "https://meet.google.com/${value.conferenceData?.conferenceId}";
            eventData = {'id': eventId, 'link': joiningLink};
          } else {
            eventData = {"status": value.status.validate()};
          }
        } else {
          log("Unable to update event in google calendar");
        }
      });
    } catch (e) {
      toast(e.toString());
      log('Error updating event $e');
    }

    return eventData;
  }

  Future<void> delete(String eventId, bool shouldNotify) async {
    const String calendarId = "primary";

    try {
      await calendar?.events.delete(calendarId, eventId, sendUpdates: shouldNotify ? "all" : "none").then((value) {});
    } catch (e) {
      log('Error deleting event: $e');
    }
  }
}
