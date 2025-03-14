// ignore_for_file: constant_identifier_names
// DO NOT USE 'dartfmt' on this file for formatting

import 'package:flutter/material.dart';

// Config
// import '../../config/config.dart';

/// A utility class for getting paths for API endpoints.
/// This class has no constructor and all methods are `static`.
@immutable
class ApiEndpoint {
  const ApiEndpoint._();

  /// The base url of our REST API, to which all the requests will be sent.
  /// It is supplied at the time of building the apk or running the app:
  /// ```
  /// flutter build apk --debug --dart-define=BASE_URL=www.some_url.com
  /// ```
  /// OR
  /// ```
  /// flutter run --dart-define=BASE_URL=www.some_url.com
  /// ```
  // static const baseUrl = 'https://dev-api.tilmidi.ma/api/v2';
  static const baseUrl = 'http://194.147.34.4:7000/api/v2';

  /// Returns the path for an authentication [endpoint].
  static String auth(AuthEndpoint endpoint) {
    switch (endpoint) {
      case AuthEndpoint.TOKEN:
        return '$baseUrl/auth/token';
    }
  }

  static String schools(SchoolsEndpoint endpoint) {
    switch (endpoint) {
      case SchoolsEndpoint.GET_ALL:
        return 'http://194.147.34.4:7000/api/v3/schools/get-all';
      // TODO: change to $baseUrl/schools/get-all
    }
  }

  static String teacherSchedule(TeacherSchedule endpoint) {
    switch (endpoint) {
      case TeacherSchedule.GET_WEEKLY_SCHEDULE:
        return '$baseUrl/teacher/journal/schedule/get';
    }
  }

  static String teacherLesson(TeacherLesson endpoint, {int? lessonId}) {
    switch (endpoint) {
      case TeacherLesson.UPDATE_LESSON:
        return '$baseUrl/teacher/journal/schedule/update_lesson/$lessonId';
    }
  }
}

/// A collection of endpoints used for authentication purposes.
enum AuthEndpoint {
  /// An endpoint for token requests.
  TOKEN,
}

enum SchoolsEndpoint { GET_ALL }

enum TeacherSchedule {
  GET_WEEKLY_SCHEDULE, // list of lessons for a week
}

enum TeacherLesson {
  UPDATE_LESSON, // update lesson
}
