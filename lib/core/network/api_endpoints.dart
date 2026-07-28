class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://wuf13.nsq4.sa/api/';
  static const String embassyUrl = 'https://az.saudiembassy.sa/ar/Pages/default.aspx?csrt=18201442976131026968';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String login = 'clients/login';
  static const String register = 'clients/register';
  static const String logout = 'clients/logout';
  static const String forgotPassword = 'auth/forgot-password';
  static const String resetPassword = 'auth/reset-password';
  static const String refreshToken = 'auth/refresh';
  static const String profile = 'clients/profile';
  static const String updateProfile = 'clients/update-profile';
  static const String updatePhoto = 'clients/update-photo';
  static const String changePassword = 'clients/change-password';

  // ─── Events ───────────────────────────────────────────────────────────────
  static const String events = 'events';
  static String eventById(int id) => 'events/$id';
  static String eventImage(int id) => 'events/$id/image';
  static String eventGallery(int id) => 'events/$id/gallery';

  // ─── Delegations ──────────────────────────────────────────────────────────
  static const String delegations = 'participating_delegations/list';

  // ─── Exhibitors ───────────────────────────────────────────────────────────
  static const String exhibitorCategories = 'exhibitor/categories';
  static const String exhibitorsList = 'exhibitor/list';
  static String exhibitorById(int id) => 'exhibitor/$id';

  // ─── Categories ───────────────────────────────────────────────────────────
  static const String categories = 'categories';

  // ─── App Settings ─────────────────────────────────────────────────────────
  static const String appSettings = 'app-setting';

  // ─── Forum Schedules ──────────────────────────────────────────────────────
  static const String forumScheduleCategories = 'forum-schedules/categories';
  static const String forumSchedulesList = 'forum-schedules/list';
  static const String myForumScheduleBookingsList =
      'forum-schedules/my-bookings/list';
  static String forumScheduleById(int id) => 'forum-schedules/$id';
  static String bookForumSchedule(int id) => 'forum-schedules/book/$id';
  static String cancelForumScheduleBooking(int id) =>
      'forum-schedules/my-bookings/cancel/$id';

  // ─── Media Centers ────────────────────────────────────────────────────────
  static const String mediaList = 'media-centers/list';

  // ─── Home ─────────────────────────────────────────────────────────────────
  static const String home = 'home';

  // ─── Explore Azerbaijan ───────────────────────────────────────────────────
  static const String exploreCategories = 'explore-azerbaijans/categories';
  static String exploreList(int categoryId) =>
      'explore-azerbaijans/list/$categoryId';

  // ─── Contact Us ───────────────────────────────────────────────────────────
  static const String contactUs = 'contact-us';

  // ─── Terms & Conditions ───────────────────────────────────────────────────
  static const String termsConditions = 'terms-conditions';

  // ─── WUF13 Tables ─────────────────────────────────────────────────────────
  static const String wuf13Tables = 'wuf13-tables';

  // ─── FCM Token ────────────────────────────────────────────────────────────
  static const String fcmToken = 'fcm-token';
}
