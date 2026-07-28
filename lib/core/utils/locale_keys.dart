// ignore_for_file: constant_identifier_names
//
// Usage: LocaleKeys.auth_login.tr()

abstract class LocaleKeys {
  // ─── App ─────────────────────────────────────────────────────────────────
  static const String app_name = 'app_name';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String auth_login = 'auth.login';
  static const String auth_logout = 'auth.logout';
  static const String auth_register = 'auth.register';
  static const String auth_email = 'auth.email';
  static const String auth_password = 'auth.password';
  static const String auth_confirmPassword = 'auth.confirm_password';
  static const String auth_forgotPassword = 'auth.forgot_password';
  static const String auth_dontHaveAccount = 'auth.dont_have_account';
  static const String auth_alreadyHaveAccount = 'auth.already_have_account';
  static const String auth_or = 'auth.or';
  static const String auth_continueAsGuest = 'auth.continue_as_guest';

  // ─── Common ───────────────────────────────────────────────────────────────
  static const String common_ok = 'common.ok';
  static const String common_cancel = 'common.cancel';
  static const String common_save = 'common.save';
  static const String common_delete = 'common.delete';
  static const String common_edit = 'common.edit';
  static const String common_search = 'common.search';
  static const String common_loading = 'common.loading';
  static const String common_error = 'common.error';
  static const String common_success = 'common.success';
  static const String common_retry = 'common.retry';
  static const String common_noData = 'common.no_data';
  static const String common_confirm = 'common.confirm';
  static const String common_back = 'common.back';
  static const String common_all = 'common.all';
  static const String common_openLink = 'common.open_link';
  static const String common_viewDetails = 'common.view_details';
  static const String common_more = 'common.more';
  static const String common_less = 'common.less';

  // ─── Events ───────────────────────────────────────────────────────────────
  static const String events_title = 'events.title';
  static const String events_create = 'events.create';
  static const String events_details = 'events.details';
  static const String events_name = 'events.name';
  static const String events_description = 'events.description';
  static const String events_date = 'events.date';
  static const String events_location = 'events.location';
  static const String events_category = 'events.category';
  static const String events_noEvents = 'events.no_events';
  static const String events_upcoming = 'events.upcoming';
  static const String events_past = 'events.past';

  // ─── Auth extras ──────────────────────────────────────────────────────────
  static const String auth_loginSubtitle = 'auth.login_subtitle';
  static const String auth_registerSubtitle = 'auth.register_subtitle';
  static const String auth_phone = 'auth.phone';
  static const String auth_name = 'auth.name';
  static const String auth_signIn = 'auth.sign_in';

  // ─── Onboarding ───────────────────────────────────────────────────────────
  static const String onboarding_skip = 'onboarding.skip';
  static const String onboarding_next = 'onboarding.next';
  static const String onboarding_getStarted = 'onboarding.get_started';
  static const String onboarding_slide1_title = 'onboarding.slide1_title';
  static const String onboarding_slide1_subtitle = 'onboarding.slide1_subtitle';
  static const String onboarding_slide2_title = 'onboarding.slide2_title';
  static const String onboarding_slide2_subtitle = 'onboarding.slide2_subtitle';
  static const String onboarding_slide3_title = 'onboarding.slide3_title';
  static const String onboarding_slide3_subtitle = 'onboarding.slide3_subtitle';

  // ─── Navigation ───────────────────────────────────────────────────────────
  static const String nav_home = 'nav.home';
  static const String nav_agenda = 'nav.forum_schedule';
  static const String nav_media = 'nav.media';
  static const String nav_assistant = 'nav.assistant';
  static const String nav_more = 'nav.more';

  // ─── Validation ───────────────────────────────────────────────────────────
  static const String validation_required = 'validation.required';
  static const String validation_invalidEmail = 'validation.invalid_email';
  static const String validation_shortPassword = 'validation.short_password';
  static const String validation_invalidPhone = 'validation.invalid_phone';

  // ─── Home ─────────────────────────────────────────────────────────────────
  static const String home_welcome = 'home.welcome';
  static const String home_eventName = 'home.event_name';
  static const String home_countdown = 'home.countdown';
  static const String home_days = 'home.days';
  static const String home_hours = 'home.hours';
  static const String home_minutes = 'home.minutes';
  static const String home_seconds = 'home.seconds';
  static const String home_quickAccess = 'home.quick_access';
  static const String home_launchTitle = 'home.launch_title';
  static const String home_launchSubtitle = 'home.launch_subtitle';
  static const String home_participantsTitle = 'home.participants_title';
  static const String home_participantsCta = 'home.participants_cta';
  static const String home_todaySessions = 'home.today_sessions';
  static const String home_filterAll = 'home.filter_all';
  static const String home_filterHighLevel = 'home.filter_high_level';
  static const String home_filterWuf = 'home.filter_wuf';

  // ─── Agenda ───────────────────────────────────────────────────────────────
  static const String agenda_title = 'forum_schedule.title';
  static const String agenda_title2 = 'forum_schedule.title2';
  static const String agenda_subtitle = 'forum_schedule.subtitle';
  static const String agenda_filterAll = 'forum_schedule.filter_all';
  static const String agenda_filterWuf = 'forum_schedule.filter_wuf';
  static const String agenda_filterHighLevel =
      'forum_schedule.filter_high_level';
  static const String agenda_noSessions = 'forum_schedule.no_sessions';
  static const String agenda_live = 'forum_schedule.live';
  static const String agenda_detailsTitle = 'forum_schedule.details_title';
  static const String agenda_detailsAbout = 'forum_schedule.details_about';
  static const String agenda_detailsSessionTime =
      'forum_schedule.details_session_time';
  static const String agenda_detailsDateTime =
      'forum_schedule.details_date_time';
  static const String agenda_detailsLocation =
      'forum_schedule.details_location';
  static const String agenda_detailsSpeakers =
      'forum_schedule.details_speakers';
  static const String agenda_detailsAddToCalendar =
      'forum_schedule.details_add_to_calendar';
  static const String agenda_detailsAddToCalendarDesc =
      'forum_schedule.details_add_to_calendar_desc';
  static const String agenda_detailsOpenCalendar =
      'forum_schedule.details_open_calendar';
  static const String agenda_detailsHowToReach =
      'forum_schedule.details_how_to_reach';
  static const String agenda_detailsReachFallback =
      'forum_schedule.details_reach_fallback';
  static const String agenda_detailsBookNow = 'forum_schedule.details_book_now';
  static const String agenda_detailsCancelBooking =
      'forum_schedule.details_cancel_booking';
  static const String agenda_detailsLiveTitle =
      'forum_schedule.details_live_title';
  static const String agenda_detailsLiveSubtitle =
      'forum_schedule.details_live_subtitle';
  static const String agenda_detailsOpenLive =
      'forum_schedule.details_open_live';
  static const String agenda_detailsBookingSuccess =
      'forum_schedule.details_booking_success';
  static const String agenda_detailsCancelSuccess =
      'forum_schedule.details_cancel_success';
  static const String agenda_detailsCancelConfirmTitle =
      'forum_schedule.details_cancel_confirm_title';
  static const String agenda_detailsCancelConfirmMessage =
      'forum_schedule.details_cancel_confirm_message';
  static const String agenda_detailsCalendarAdded =
      'forum_schedule.details_calendar_added';
  static const String agenda_detailsCalendarAlreadyAdded =
      'forum_schedule.details_calendar_already_added';

  // ─── Media ────────────────────────────────────────────────────────────────
  static const String media_title = 'media.title';
  static const String media_title2 = 'media.title2';
  static const String media_subtitle = 'media.subtitle';
  static const String media_news = 'media.news';
  static const String media_videos = 'media.videos';
  static const String media_articles = 'media.articles';
  static const String media_details = 'media.details';
  static const String media_typeImage = 'media.type_image';
  static const String media_typeVideo = 'media.type_video';

  // ─── Assistant ────────────────────────────────────────────────────────────
  static const String assistant_title = 'assistant.title';
  static const String assistant_hint = 'assistant.hint';
  static const String assistant_faq = 'assistant.faq';
  static const String assistant_greeting = 'assistant.greeting';

  static const String open_map = 'open_map';
  static const String back = 'back';

  // ─── More ─────────────────────────────────────────────────────────────────

  static const String more_title = 'more.title';
  static const String more_map = 'more.map';
  static const String more_map2 = 'more.map2';
  static const String more_mapSubtitle = 'more.map_subtitle';
  static const String more_prayer = 'more.prayer';
  static const String more_prayerSubtitle = 'more.prayer_subtitle';
  static const String more_embassy = 'more.embassy';
  static const String more_embassySubtitle = 'more.embassy_subtitle';
  static const String more_exhibitors = 'more.exhibitors';
  static const String more_exhibitorsSubtitle = 'more.exhibitors_subtitle';
  static const String more_explore = 'more.explore';
  static const String more_explore2 = 'more.explore2';
  static const String more_exploreSubtitle = 'more.explore_subtitle';
  static const String more_indoorNavigate = 'more.indoor_navigate';
  static const String more_indoorNavigateSubtitle =
      'more.indoor_navigate_subtitle';
  static const String more_myBookings = 'more.my_bookings';
  static const String more_myBookingsSubtitle = 'more.my_bookings_subtitle';
  static const String more_myBookingsEmpty = 'more.my_bookings_empty';
  static const String more_participants = 'more.participants';
  static const String more_wuf13Tables = 'more.wuf13_tables';
  static const String more_wuf13TablesSubtitle = 'more.wuf13_tables_subtitle';
  static const String more_linksTitle = 'more.links_title';
  static const String more_linksSubtitle = 'more.links_subtitle';
  static const String more_profileCardSubtitle =
      'more.profile_card_subtitle';

  // ─── Indoor map / navigation ─────────────────────────────────────────────
  static const String indoorMap_title = 'indoor_map.title';
  static const String indoorMap_navigate = 'indoor_map.navigate';
  static const String indoorMap_selectDestination =
      'indoor_map.select_destination';
  static const String indoorMap_searchHint = 'indoor_map.search_hint';
  static const String indoorMap_takeElevatorUp =
      'indoor_map.take_elevator_up';
  static const String indoorMap_takeElevatorDown =
      'indoor_map.take_elevator_down';
  static const String indoorMap_takeStairsUp = 'indoor_map.take_stairs_up';
  static const String indoorMap_takeStairsDown =
      'indoor_map.take_stairs_down';
  static const String indoorMap_headTowards = 'indoor_map.head_towards';
  static const String indoorMap_arrived = 'indoor_map.arrived';
  static const String indoorMap_floor = 'indoor_map.floor';
  static const String indoorMap_noPath = 'indoor_map.no_path';
  static const String indoorMap_clearRoute = 'indoor_map.clear_route';
  static const String indoorMap_elevatorFallback =
      'indoor_map.elevator_fallback';
  static const String indoorMap_stairsFallback = 'indoor_map.stairs_fallback';
  static const String indoorMap_entranceFallback =
      'indoor_map.entrance_fallback';
  static const String indoorMap_transitionFallback =
      'indoor_map.transition_fallback';
  static const String indoorMap_routeStats = 'indoor_map.route_stats';
  static const String indoorMap_tapRoomHint = 'indoor_map.tap_room_hint';

  // ─── Participants ─────────────────────────────────────────────────────────
  static const String participants_title = 'participants.title';
  static const String participants_subtitle = 'participants.subtitle';
  static const String participants_sectionTitle = 'participants.section_title';
  static const String participants_description = 'participants.description';
  static const String participants_countSuffix = 'participants.count_suffix';
  static const String participants_roleChip = 'participants.role_chip';

  // ─── Exhibitors ───────────────────────────────────────────────────────────
  static const String exhibitors_title = 'exhibitors.title';
  static const String exhibitors_subtitle = 'exhibitors.subtitle';
  static const String exhibitors_searchHint = 'exhibitors.search_hint';
  static const String exhibitors_booth = 'exhibitors.booth';
  static const String exhibitors_hall = 'exhibitors.hall';
  static const String exhibitors_countSuffix = 'exhibitors.count_suffix';
  static const String exhibitors_detailsTitle = 'exhibitors.details_title';
  static const String exhibitors_description = 'exhibitors.description';
  static const String exhibitors_about = 'exhibitors.about';
  static const String exhibitors_services = 'exhibitors.services';
  static const String exhibitors_socialLinks = 'exhibitors.social_links';
  static const String exhibitors_detailsSubtitle =
      'exhibitors.details_subtitle';
  static const String exhibitors_featured = 'exhibitors.featured';
  static const String exhibitors_visitBooth = 'exhibitors.visit_booth';
  static const String exhibitors_visitBoothShort =
      'exhibitors.visit_booth_short';

  // ─── Profile ──────────────────────────────────────────────────────────────
  static const String profile_title = 'profile.title';
  static const String profile_subtitle = 'profile.subtitle';
  static const String profile_name = 'profile.name';
  static const String profile_email = 'profile.email';
  static const String profile_phone = 'profile.phone';
  static const String profile_joinedAt = 'profile.joined_at';
  static const String profile_editProfile = 'profile.edit_profile';
  static const String profile_logout = 'profile.logout';
  static const String profile_guest = 'profile.guest';
  static const String profile_guestSubtitle = 'profile.guest_subtitle';
  static const String profile_loginNow = 'profile.login_now';
  static const String profile_accountData = 'profile.account_data';
  static const String profile_accountNumber = 'profile.account_number';
  static const String profile_editInfo = 'profile.edit_info';
  static const String profile_saveInfo = 'profile.save_info';
  static const String profile_cancel = 'profile.cancel';
  static const String profile_updatePassword = 'profile.update_password';
  static const String profile_clearFields = 'profile.clear_fields';
  static const String profile_registeredVisitor = 'profile.registered_visitor';
  static const String profile_activeEntry = 'profile.active_entry';
  static const String profile_eventBadge = 'profile.event_badge';
  static const String profile_emptyBookingsPrefix =
      'profile.empty_bookings_prefix';
  static const String profile_emptyBookingsAction =
      'profile.empty_bookings_action';
  static const String profile_emptyBookingsSuffix =
      'profile.empty_bookings_suffix';

  // ─── Explore Azerbaijan ───────────────────────────────────────────────────
  static const String explore_title = 'explore.title';
  static const String explore_subtitle = 'explore.subtitle';
  static const String explore_bannerTitle = 'explore.banner_title';
  static const String explore_bannerSubtitle = 'explore.banner_subtitle';
  static const String explore_countSuffix = 'explore.count_suffix';

  // ─── Expo map ───────────────────────────────────────────────────────────────
  static const String expoMap_title = 'expo_map.title';
  static const String expoMap_searchHint = 'expo_map.search_hint';
  static const String expoMap_filterSaudiPavilion = 'expo_map.filter_saudi_pavilion';
  static const String expoMap_loadError = 'expo_map.load_error';
  static const String expoMap_zoneWithCode = 'expo_map.zone_with_code';
  static const String expoMap_saudiPavilionTitle =
      'expo_map.saudi_pavilion_title';
  static const String expoMap_ministryName = 'expo_map.ministry_name';
  static const String expoMap_saudiExhibitorsCount =
      'expo_map.saudi_exhibitors_count';

  // ─── Expo map booth panel ──────────────────────────────────────────────────
  static const String expoMap_boothOrganization = 'expo_map.booth_organization';
  static const String expoMap_boothCategory = 'expo_map.booth_category';
  static const String expoMap_boothZone = 'expo_map.booth_zone';
  static const String expoMap_boothAbout = 'expo_map.booth_about';

  // ─── Expo map booth categories ─────────────────────────────────────────────
  static const String expoMap_catNationalGov = 'expo_map.cat_national_gov';
  static const String expoMap_catInterGov =
      'expo_map.cat_inter_gov';
  static const String expoMap_catPublicPrivate = 'expo_map.cat_public_private';
  static const String expoMap_catCivil = 'expo_map.cat_civil';
  static const String expoMap_catAcademia = 'expo_map.cat_academia';
  static const String expoMap_catUn = 'expo_map.cat_un';

  // ─── Prayer Timings ────────────────────────────────────────────────────────
  static const String prayer_title = 'prayer.title';
  static const String prayer_subtitle = 'prayer.subtitle';
  static const String prayer_nextPrayer = 'prayer.next_prayer';
  static const String prayer_fajr = 'prayer.fajr';
  static const String prayer_sunrise = 'prayer.sunrise';
  static const String prayer_dhuhr = 'prayer.dhuhr';
  static const String prayer_asr = 'prayer.asr';
  static const String prayer_maghrib = 'prayer.maghrib';
  static const String prayer_isha = 'prayer.isha';
  static const String prayer_location = 'prayer.location';
  static const String prayer_hijriDate = 'prayer.hijri_date';
  static const String prayer_loadingLocation = 'prayer.loading_location';
  static const String prayer_errorLocation = 'prayer.error_location';
  static const String prayer_permissionDenied = 'prayer.permission_denied';
  static const String prayer_enableLocation = 'prayer.enable_location';
  static const String prayer_remainingTime = 'prayer.remaining_time';
  static const String prayer_qiblahTitle = 'prayer.qiblah_title';
  static const String prayer_qiblahHint = 'prayer.qiblah_hint';
  static const String prayer_qiblahSurfaceHint = 'prayer.qiblah_surface_hint';
  static const String prayer_qiblahError = 'prayer.qiblah_error';
  static const String prayer_qiblahPermissionDenied =
      'prayer.qiblah_permission_denied';
  static const String prayer_qiblahPermissionForever =
      'prayer.qiblah_permission_forever';
  static const String prayer_qiblahPermissionForeverSubtitle =
      'prayer.qiblah_permission_forever_subtitle';
  static const String prayer_qiblahEnableLocation =
      'prayer.qiblah_enable_location';
  static const String prayer_qiblahEnableLocationSubtitle =
      'prayer.qiblah_enable_location_subtitle';
  static const String prayer_qiblahDirectionAhead =
      'prayer.qiblah_direction_ahead';
  static const String prayer_qiblahDirectionLeft =
      'prayer.qiblah_direction_left';
  static const String prayer_qiblahDirectionRight =
      'prayer.qiblah_direction_right';
  static const String prayer_qiblahDirectionBehind =
      'prayer.qiblah_direction_behind';
  static const String prayer_qiblahTurnLeft = 'prayer.qiblah_turn_left';
  static const String prayer_qiblahTurnRight = 'prayer.qiblah_turn_right';
  static const String prayer_qiblahTurnAround = 'prayer.qiblah_turn_around';
  static const String prayer_qiblahAligned = 'prayer.qiblah_aligned';

  // ─── Errors ───────────────────────────────────────────────────────────────
  static const String error_network = 'error.network';
  static const String error_server = 'error.server';
  static const String error_unauthorized = 'error.unauthorized';
  static const String error_notFound = 'error.not_found';
  static const String error_timeout = 'error.timeout';

  // ─── More (extra) ─────────────────────────────────────────────────────────
  static const String more_settings = 'more.settings';
  static const String more_settingsSubtitle = 'more.settings_subtitle';

  // ─── Settings ──────────────────────────────────────────────────────────────
  static const String settings_title = 'settings.title';
  static const String settings_headerSubtitle = 'settings.header_subtitle';

  static const String settings_updateProfile = 'settings.update_profile';
  static const String settings_updateProfileSubtitle =
      'settings.update_profile_subtitle';

  static const String settings_changePassword = 'settings.change_password';
  static const String settings_changePasswordSubtitle =
      'settings.change_password_subtitle';

  static const String settings_changeLanguage = 'settings.change_language';
  static const String settings_changeLanguageSubtitle =
      'settings.change_language_subtitle';

  static const String settings_logout = 'settings.logout';
  static const String settings_logoutSubtitle = 'settings.logout_subtitle';

  static const String settings_deleteAccount = 'settings.delete_account';
  static const String settings_deleteAccountSubtitle =
      'settings.delete_account_subtitle';

  static const String settings_labelName = 'settings.label_name';
  static const String settings_labelEmail = 'settings.label_email';
  static const String settings_labelPhone = 'settings.label_phone';
  static const String settings_saveChanges = 'settings.save_changes';

  static const String settings_oldPassword = 'settings.old_password';
  static const String settings_newPassword = 'settings.new_password';
  static const String settings_confirmNewPassword =
      'settings.confirm_new_password';
  static const String settings_passwordMismatch = 'settings.password_mismatch';

  static const String settings_languageTitle = 'settings.language_title';
  static const String settings_arabic = 'settings.arabic';
  static const String settings_english = 'settings.english';

  static const String settings_logoutDialogTitle =
      'settings.logout_dialog_title';
  static const String settings_logoutDialogMessage =
      'settings.logout_dialog_message';

  static const String settings_deleteDialogTitle =
      'settings.delete_dialog_title';
  static const String settings_deleteDialogMessage =
      'settings.delete_dialog_message';

  static const String settings_contactUs = 'settings.contact_us';
  static const String settings_contactUsSubtitle =
      'settings.contact_us_subtitle';
  static const String settings_terms = 'settings.terms';
  static const String settings_termsSubtitle = 'settings.terms_subtitle';

  // ─── Contact Us ───────────────────────────────────────────────────────────
  static const String contactUs_title = 'contact_us.title';
  static const String contactUs_subtitle = 'contact_us.subtitle';
  static const String contactUs_name = 'contact_us.name';
  static const String contactUs_email = 'contact_us.email';
  static const String contactUs_phone = 'contact_us.phone';
  static const String contactUs_message = 'contact_us.message';
  static const String contactUs_send = 'contact_us.send';
  static const String contactUs_successMessage = 'contact_us.success_message';

  // ─── Terms & Conditions ───────────────────────────────────────────────────
  static const String terms_title = 'terms.title';
}
