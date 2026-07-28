import 'package:app_base/app/router/navigation_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ConvertHelper {
  static String formatDateTime(
    String date, {
    String? time,
    bool includeDate = true,
    bool includeTime = false,
  }) {
    if (date.isEmpty && (time == null || time.isEmpty)) return '';

    final dateTime = _parseDateTime(date, time: time);
    if (dateTime == null) {
      return [date, time]
          .where((value) => value != null && value.trim().isNotEmpty)
          .map((value) => value!.trim())
          .join(' - ');
    }

    final locale = _languageCode;
    final parts = <String>[];

    if (includeDate) {
      final dateFormat = DateFormat('d MMMM y', locale);
      parts.add(dateFormat.format(dateTime));
    }

    if (includeTime) {
      if (locale == 'ar') {
        final timeFormat = DateFormat('hh:mm', locale);
        final period = dateTime.hour < 12 ? 'صباحًا' : 'مساءً';
        parts.add('${timeFormat.format(dateTime)} $period');
      } else {
        final timeFormat = DateFormat('hh:mm a', locale);
        parts.add(timeFormat.format(dateTime));
      }
    }

    return parts.join(' - ');
  }

  static String formatDuration(String duration) {
    final minutes = int.tryParse(duration.trim());
    if (minutes == null || minutes <= 0) return duration;

    if (_languageCode == 'ar') {
      return '$minutes دقيقة';
    }

    return '$minutes min';
  }

  static DateTime? _parseDateTime(String date, {String? time}) {
    final normalizedDate = date.trim();
    final normalizedTime = (time ?? '').trim();

    final candidates = <String>[
      if (normalizedDate.isNotEmpty && normalizedTime.isNotEmpty)
        '${normalizedDate}T${_normalizeTime(normalizedTime)}',
      if (normalizedDate.isNotEmpty) normalizedDate,
    ];

    for (final value in candidates) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }

    return null;
  }

  static String _normalizeTime(String time) {
    final parts = time.split(':');
    if (parts.length == 2) {
      return '${parts[0]}:${parts[1]}:00';
    }
    return time;
  }

  static String get _languageCode {
    final context = NavigationService.navigationKey.currentContext;
    if (context != null) {
      return Localizations.localeOf(context).languageCode;
    }

    final locale = Intl.getCurrentLocale();
    if (locale.isEmpty) return 'en';
    return locale.split('_').first;
  }
}
