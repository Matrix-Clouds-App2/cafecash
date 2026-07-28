import 'package:equatable/equatable.dart';

import '../../../home/presentation/widgets/home_participant_card.dart';

// ── Slider ────────────────────────────────────────────────────────────────────

class HomeSliderModel extends Equatable {
  const HomeSliderModel({
    required this.id,
    required this.title,
    required this.image,
    required this.mainTitle,
    required this.description,
  });

  final int id;
  final String title;
  final String image;
  final String mainTitle;
  final String description;

  bool get hasDetailsContent =>
      mainTitle.trim().isNotEmpty || description.trim().isNotEmpty;

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) =>
      HomeSliderModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        image: json['image'] as String? ?? '',
        mainTitle: json['main_title'] as String? ?? '',
        description: json['description'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, title, image, mainTitle, description];
}

// ── Settings ──────────────────────────────────────────────────────────────────

class HomeSettingsModel extends Equatable {
  const HomeSettingsModel({
    required this.eventTitle,
    this.startDate,
    this.endDate,
    required this.eventStartDate,
    required this.eventEndDate,
    required this.eventLocation,
  });

  final String eventTitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final String eventStartDate;
  final String eventEndDate;
  final String eventLocation;

  factory HomeSettingsModel.fromJson(Map<String, dynamic> json) {
    DateTime? tryParse(String? v) {
      if (v == null || v.isEmpty) return null;
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }

    final startRaw = json['event_start_date'] as String?;
    final endRaw = json['event_end_date'] as String?;

    return HomeSettingsModel(
      eventTitle: json['event_title'] as String? ?? '',
      startDate: tryParse(startRaw),
      endDate: tryParse(endRaw),
      eventStartDate: startRaw ?? '',
      eventEndDate: endRaw ?? '',
      eventLocation: json['event_location'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props =>
      [eventTitle, startDate, endDate, eventLocation];
}

// ── Forum category ─────────────────────────────────────────────────────────────

class HomeForumCategoryModel extends Equatable {
  const HomeForumCategoryModel({required this.id, required this.name});

  final int id;
  final String name;

  factory HomeForumCategoryModel.fromJson(Map<String, dynamic> json) =>
      HomeForumCategoryModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, name];
}

// ── Forum hall ────────────────────────────────────────────────────────────────

class HomeForumHallModel extends Equatable {
  const HomeForumHallModel({required this.id, required this.name});

  final int id;
  final String name;

  factory HomeForumHallModel.fromJson(Map<String, dynamic> json) =>
      HomeForumHallModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
      );

  @override
  List<Object?> get props => [id, name];
}

// ── Forum (session) ───────────────────────────────────────────────────────────

class HomeForumModel extends Equatable {
  const HomeForumModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.category,
    required this.hall,
  });

  final int id;
  final String title;
  final String description;
  final String date;
  final String startTime;
  final String duration;
  final HomeForumCategoryModel category;
  final HomeForumHallModel hall;

  factory HomeForumModel.fromJson(Map<String, dynamic> json) =>
      HomeForumModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        date: json['date'] as String? ?? '',
        startTime: json['start_time'] as String? ?? '',
        duration: json['duration'] as String? ?? '',
        category: HomeForumCategoryModel.fromJson(
            json['category'] as Map<String, dynamic>),
        hall: HomeForumHallModel.fromJson(
            json['hall'] as Map<String, dynamic>),
      );

  String get formattedTime {
    try {
      final parts = startTime.split(':');
      final h = int.parse(parts[0]);
      final m = parts[1];
      final suffix = h >= 12 ? 'م' : 'ص';
      final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '$hour:$m $suffix';
    } catch (_) {
      return startTime;
    }
  }

  @override
  List<Object?> get props => [id, title, date, startTime, category, hall];
}

// ── Root model ────────────────────────────────────────────────────────────────

class HomeModel extends Equatable {
  const HomeModel({
    required this.sliders,
    required this.settings,
    required this.participatingDelegations,
    required this.categories,
    required this.forums,
  });

  final List<HomeSliderModel> sliders;
  final HomeSettingsModel settings;
  final List<ParticipantModel> participatingDelegations;
  final List<HomeForumCategoryModel> categories;
  final List<HomeForumModel> forums;

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return HomeModel(
      sliders: (data['sliders'] as List<dynamic>)
          .map((e) => HomeSliderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      settings: HomeSettingsModel.fromJson(
          data['settings'] as Map<String, dynamic>),
      participatingDelegations:
          (data['participating_delegations'] as List<dynamic>)
              .map((e) =>
                  ParticipantModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      categories: (data['categories'] as List<dynamic>)
          .map((e) =>
              HomeForumCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      forums: (data['forums'] as List<dynamic>)
          .map((e) =>
              HomeForumModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props =>
      [sliders, settings, participatingDelegations, categories, forums];
}
