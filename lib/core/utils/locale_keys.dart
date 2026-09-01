// ignore_for_file: constant_identifier_names
//
// Usage: LocaleKeys.auth_login.tr()

abstract class LocaleKeys {
  // ─── App ─────────────────────────────────────────────────────────────────
  static const String app_name = 'app_name';

  // ─── Auth ─────────────────────────────────────────────────────────────────
  static const String auth_login = 'auth.login';
  static const String auth_register = 'auth.register';
  static const String auth_email = 'auth.email';
  static const String auth_password = 'auth.password';
  static const String auth_dontHaveAccount = 'auth.dont_have_account';
  static const String auth_alreadyHaveAccount = 'auth.already_have_account';
  static const String auth_or = 'auth.or';
  static const String auth_continueAsGuest = 'auth.continue_as_guest';
  static const String auth_registerSubtitle = 'auth.register_subtitle';
  static const String auth_phone = 'auth.phone';
  static const String auth_name = 'auth.name';
  static const String auth_cafeName = 'auth.cafe_name';
  static const String auth_signIn = 'auth.sign_in';

  // ─── OTP ──────────────────────────────────────────────────────────────────
  static const String otp_title = 'otp.title';
  static const String otp_subtitle = 'otp.subtitle';
  static const String otp_verify = 'otp.verify';
  static const String otp_resendIn = 'otp.resend_in';
  static const String otp_resend = 'otp.resend';
  static const String otp_changeNumber = 'otp.change_number';
  static const String otp_invalidCode = 'otp.invalid_code';

  // ─── Common ───────────────────────────────────────────────────────────────
  static const String common_cancel = 'common.cancel';
  static const String common_ok = 'common.ok';
  static const String common_search = 'common.search';
  static const String common_retry = 'common.retry';
  static const String common_confirm = 'common.confirm';
  static const String common_currency = 'common.currency';
  static const String common_apply = 'common.apply';
  static const String common_save = 'common.save';
  static const String common_edit = 'common.edit';
  static const String common_delete = 'common.delete';
  static const String common_add = 'common.add';
  static const String common_name = 'common.name';
  static const String common_phone = 'common.phone';
  static const String common_cancelReasonHint = 'common.cancel_reason_hint';

  // ─── Validation ───────────────────────────────────────────────────────────
  static const String validation_required = 'validation.required';
  static const String validation_invalidEmail = 'validation.invalid_email';
  static const String validation_shortPassword = 'validation.short_password';
  static const String validation_invalidPhone = 'validation.invalid_phone';

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
  static const String nav_more = 'nav.more';
  static const String nav_treasury = 'nav.treasury';
  static const String nav_payments = 'nav.payments';
  static const String nav_matches = 'nav.matches';
  static const String nav_hall = 'nav.hall';

  // ─── Home ─────────────────────────────────────────────────────────────────
  static const String home_welcome = 'home.welcome';

  // ─── Treasury ─────────────────────────────────────────────────────────────
  static const String treasury_currentBalance = 'treasury.current_balance';
  static const String treasury_totalExpense = 'treasury.total_expense';
  static const String treasury_totalIncome = 'treasury.total_income';
  static const String treasury_withdrawCash = 'treasury.withdraw_cash';
  static const String treasury_receiveCash = 'treasury.receive_cash';
  static const String treasury_recentTransactions =
      'treasury.recent_transactions';
  static const String treasury_noTransactions = 'treasury.no_transactions';
  static const String treasury_orderPaymentSubtitle =
      'treasury.order_payment_subtitle';
  static const String treasury_includesOpeningBalance =
      'treasury.includes_opening_balance';
  static const String treasury_partialPaymentSubtitle =
      'treasury.partial_payment_subtitle';
  static const String treasury_deferredCollectionSubtitle =
      'treasury.deferred_collection_subtitle';
  static const String treasury_receiveInfoTitle = 'treasury.receive_info_title';
  static const String treasury_receiveInfoExample =
      'treasury.receive_info_example';
  static const String treasury_withdrawInfoTitle =
      'treasury.withdraw_info_title';
  static const String treasury_withdrawInfoExample =
      'treasury.withdraw_info_example';
  static const String treasury_amountLabel = 'treasury.amount_label';
  static const String treasury_notesLabel = 'treasury.notes_label';
  static const String treasury_amountInvalid = 'treasury.amount_invalid';
  static const String treasury_saveReceipt = 'treasury.save_receipt';
  static const String treasury_receiptSaved = 'treasury.receipt_saved';
  static const String treasury_manualIncomeSubtitle =
      'treasury.manual_income_subtitle';
  static const String treasury_manualExpenseSubtitle =
      'treasury.manual_expense_subtitle';
  static const String treasury_recordedBy = 'treasury.recorded_by';
  static const String treasury_filterTitle = 'treasury.filter_title';
  static const String treasury_searchHint = 'treasury.search_hint';
  static const String treasury_noSearchResults = 'treasury.no_search_results';
  static const String treasury_sortNewest = 'treasury.sort_newest';
  static const String treasury_sortOldest = 'treasury.sort_oldest';
  static const String treasury_sortAmountHigh = 'treasury.sort_amount_high';
  static const String treasury_sortAmountLow = 'treasury.sort_amount_low';
  static const String treasury_totalCash = 'treasury.total_cash';
  static const String treasury_totalWallet = 'treasury.total_wallet';
  static const String treasury_paymentMethodUpdated =
      'treasury.payment_method_updated';
  static const String treasury_paymentMethodUpdatedNoLink =
      'treasury.payment_method_updated_no_link';

  // ─── Shift ────────────────────────────────────────────────────────────────
  static const String shift_title = 'shift.title';
  static const String shift_question = 'shift.question';
  static const String shift_amountHint = 'shift.amount_hint';
  static const String shift_startButton = 'shift.start_button';
  static const String shift_amountInvalid = 'shift.amount_invalid';
  static const String shift_summaryTitle = 'shift.summary_title';
  static const String shift_openingBalance = 'shift.opening_balance';
  static const String shift_closingBalance = 'shift.closing_balance';
  static const String shift_closingBalanceNote = 'shift.closing_balance_note';
  static const String shift_ordersSummary = 'shift.orders_summary';
  static const String shift_ordersCount = 'shift.orders_count';
  static const String shift_itemsSold = 'shift.items_sold';
  static const String shift_myOrders = 'shift.my_orders';
  static const String shift_closeButton = 'shift.close_button';
  static const String shift_closedBadge = 'shift.closed_badge';
  static const String shift_closeConfirmTitle = 'shift.close_confirm_title';
  static const String shift_closeConfirmMessage = 'shift.close_confirm_message';
  static const String shift_occupiedBlockingTitle =
      'shift.occupied_blocking_title';
  static const String shift_occupiedBlockingMessage =
      'shift.occupied_blocking_message';
  static const String shift_startedAt = 'shift.started_at';
  static const String shift_endedAt = 'shift.ended_at';
  static const String shift_ongoing = 'shift.ongoing';
  static const String shift_historyTitle = 'shift.history_title';
  static const String shift_historyEmpty = 'shift.history_empty';
  static const String shift_noActiveShift = 'shift.no_active_shift';
  static const String shift_cancelledOrdersEmpty =
      'shift.cancelled_orders_empty';
  static const String shift_remoteDetailsUnavailableTitle =
      'shift.remote_details_unavailable_title';
  static const String shift_remoteDetailsUnavailableMessage =
      'shift.remote_details_unavailable_message';

  // ─── Hall ─────────────────────────────────────────────────────────────────
  static const String hall_readyBadge = 'hall.ready_badge';
  static const String hall_occupiedBadge = 'hall.occupied_badge';
  static const String hall_disabledBadge = 'hall.disabled_badge';
  static const String hall_tableLabel = 'hall.table_label';
  static const String hall_drinkCount = 'hall.drink_count';
  static const String hall_disableOption = 'hall.disable_option';
  static const String hall_deleteOption = 'hall.delete_option';
  static const String hall_deleteTitle = 'hall.delete_title';
  static const String hall_deleteMessage = 'hall.delete_message';
  static const String hall_deleteConfirm = 'hall.delete_confirm';
  static const String hall_reactivateTitle = 'hall.reactivate_title';
  static const String hall_reactivateMessage = 'hall.reactivate_message';
  static const String hall_reactivateConfirm = 'hall.reactivate_confirm';
  static const String hall_settingsTitle = 'hall.settings_title';
  static const String hall_columnsPerRow = 'hall.columns_per_row';
  static const String hall_searchHint = 'hall.search_hint';
  static const String hall_filterTitle = 'hall.filter_title';
  static const String hall_sortNumberAsc = 'hall.sort_number_asc';
  static const String hall_sortNumberDesc = 'hall.sort_number_desc';
  static const String hall_sortPriceAsc = 'hall.sort_price_asc';
  static const String hall_sortPriceDesc = 'hall.sort_price_desc';
  static const String hall_cancelOrderMessage = 'hall.cancel_order_message';

  // ─── Payments ─────────────────────────────────────────────────────────────
  static const String payments_paidBadge = 'payments.paid_badge';
  static const String payments_items = 'payments.items';
  static const String payments_empty = 'payments.empty';
  static const String payments_invoiceLabel = 'payments.invoice_label';
  static const String payments_tablesTab = 'payments.tables_tab';
  static const String payments_seatsTab = 'payments.seats_tab';

  // ─── Matches ──────────────────────────────────────────────────────────────
  static const String matches_readyBadge = 'matches.ready_badge';
  static const String matches_occupiedBadge = 'matches.occupied_badge';
  static const String matches_disabledBadge = 'matches.disabled_badge';
  static const String matches_seatLabel = 'matches.seat_label';
  static const String matches_disableOption = 'matches.disable_option';
  static const String matches_deleteOption = 'matches.delete_option';
  static const String matches_deleteTitle = 'matches.delete_title';
  static const String matches_deleteMessage = 'matches.delete_message';
  static const String matches_deleteConfirm = 'matches.delete_confirm';
  static const String matches_reactivateTitle = 'matches.reactivate_title';
  static const String matches_reactivateMessage = 'matches.reactivate_message';
  static const String matches_reactivateConfirm = 'matches.reactivate_confirm';
  static const String matches_settingsTitle = 'matches.settings_title';
  static const String matches_columnsPerRow = 'matches.columns_per_row';
  static const String matches_searchHint = 'matches.search_hint';
  static const String matches_filterTitle = 'matches.filter_title';
  static const String matches_sortNumberAsc = 'matches.sort_number_asc';
  static const String matches_sortNumberDesc = 'matches.sort_number_desc';
  static const String matches_sortPriceAsc = 'matches.sort_price_asc';
  static const String matches_sortPriceDesc = 'matches.sort_price_desc';
  static const String matches_seatDetails = 'matches.seat_details';
  static const String matches_cancelOrderMessage =
      'matches.cancel_order_message';

  // ─── More ─────────────────────────────────────────────────────────────────
  static const String more_title = 'more.title';
  static const String more_profileCardSubtitle = 'more.profile_card_subtitle';

  // ─── Profile ──────────────────────────────────────────────────────────────
  static const String profile_title = 'profile.title';
  static const String profile_loginNow = 'profile.login_now';
  static const String profile_updateTitle = 'profile.update_title';
  static const String profile_updateSubtitle = 'profile.update_subtitle';
  static const String profile_nameLabel = 'profile.name_label';
  static const String profile_nameHint = 'profile.name_hint';
  static const String profile_nameRequired = 'profile.name_required';
  static const String profile_updateButton = 'profile.update_button';
  static const String profile_updateSuccess = 'profile.update_success';

  // ─── Settings ─────────────────────────────────────────────────────────────
  static const String settings_changeLanguage = 'settings.change_language';
  static const String settings_changeLanguageSubtitle =
      'settings.change_language_subtitle';
  static const String settings_languageTitle = 'settings.language_title';
  static const String settings_arabic = 'settings.arabic';
  static const String settings_english = 'settings.english';
  static const String settings_logout = 'settings.logout';
  static const String settings_logoutSubtitle = 'settings.logout_subtitle';
  static const String settings_logoutDialogTitle =
      'settings.logout_dialog_title';
  static const String settings_logoutDialogMessage =
      'settings.logout_dialog_message';
  static const String settings_termsConditions = 'settings.terms_conditions';
  static const String settings_termsConditionsSubtitle =
      'settings.terms_conditions_subtitle';
  static const String settings_aboutUs = 'settings.about_us';
  static const String settings_aboutUsSubtitle = 'settings.about_us_subtitle';
  static const String settings_deleteAccount = 'settings.delete_account';
  static const String settings_deleteAccountSubtitle =
      'settings.delete_account_subtitle';
  static const String settings_deleteAccountDialogTitle =
      'settings.delete_account_dialog_title';
  static const String settings_deleteAccountDialogMessage =
      'settings.delete_account_dialog_message';
  static const String settings_deleteAccountConfirm =
      'settings.delete_account_confirm';
  static const String settings_termsSection1Title =
      'settings.terms_section1_title';
  static const String settings_termsSection1Body =
      'settings.terms_section1_body';
  static const String settings_termsSection2Title =
      'settings.terms_section2_title';
  static const String settings_termsSection2Body =
      'settings.terms_section2_body';
  static const String settings_termsSection3Title =
      'settings.terms_section3_title';
  static const String settings_termsSection3Body =
      'settings.terms_section3_body';
  static const String settings_termsSection4Title =
      'settings.terms_section4_title';
  static const String settings_termsSection4Body =
      'settings.terms_section4_body';
  static const String settings_termsSection5Title =
      'settings.terms_section5_title';
  static const String settings_termsSection5Body =
      'settings.terms_section5_body';
  static const String settings_aboutSection1Title =
      'settings.about_section1_title';
  static const String settings_aboutSection1Body =
      'settings.about_section1_body';
  static const String settings_aboutSection2Title =
      'settings.about_section2_title';
  static const String settings_aboutSection2Body =
      'settings.about_section2_body';
  static const String settings_aboutSection3Title =
      'settings.about_section3_title';
  static const String settings_aboutSection3Body =
      'settings.about_section3_body';
  static const String settings_aboutSection4Title =
      'settings.about_section4_title';
  static const String settings_aboutSection4Body =
      'settings.about_section4_body';
  static const String settings_privacyPolicy = 'settings.privacy_policy';
  static const String settings_privacyPolicySubtitle =
      'settings.privacy_policy_subtitle';
  static const String settings_privacySection1Title =
      'settings.privacy_section1_title';
  static const String settings_privacySection1Body =
      'settings.privacy_section1_body';
  static const String settings_privacySection2Title =
      'settings.privacy_section2_title';
  static const String settings_privacySection2Body =
      'settings.privacy_section2_body';
  static const String settings_privacySection3Title =
      'settings.privacy_section3_title';
  static const String settings_privacySection3Body =
      'settings.privacy_section3_body';
  static const String settings_privacySection4Title =
      'settings.privacy_section4_title';
  static const String settings_privacySection4Body =
      'settings.privacy_section4_body';
  static const String settings_privacySection5Title =
      'settings.privacy_section5_title';
  static const String settings_privacySection5Body =
      'settings.privacy_section5_body';
  static const String settings_subscriptionPlans =
      'settings.subscription_plans';
  static const String settings_subscriptionPlansSubtitle =
      'settings.subscription_plans_subtitle';
  static const String settings_comingSoonBadge = 'settings.coming_soon_badge';
  static const String settings_walletPaymentTitle =
      'settings.wallet_payment_title';
  static const String settings_walletPaymentDescription =
      'settings.wallet_payment_description';

  // ─── Drawer ───────────────────────────────────────────────────────────────
  static const String drawer_myAccount = 'drawer.my_account';
  static const String drawer_closeShift = 'drawer.close_shift';
  static const String drawer_shifts = 'drawer.shifts';
  static const String drawer_customersManagement =
      'drawer.customers_management';
  static const String drawer_employeesManagement =
      'drawer.employees_management';
  static const String drawer_matchesScreenSettings =
      'drawer.matches_screen_settings';
  static const String drawer_itemsManagement = 'drawer.items_management';
  static const String drawer_deferredAccounts = 'drawer.deferred_accounts';
  static const String drawer_cancelledOrders = 'drawer.cancelled_orders';
  static const String drawer_settings = 'drawer.settings';
  static const String drawer_receiveShift = 'drawer.receive_shift';
  static const String drawer_handoverShift = 'drawer.handover_shift';
  static const String drawer_usagePolicy = 'drawer.usage_policy';
  static const String drawer_comingSoon = 'drawer.coming_soon';
  static const String drawer_contactUs = 'drawer.contact_us';
  static const String drawer_contactUsError = 'drawer.contact_us_error';

  // ─── Items (categories/menu management) ────────────────────────────────────
  static const String items_chooseImage = 'items.choose_image';
  static const String items_pickFromCamera = 'items.pick_from_camera';
  static const String items_pickFromGallery = 'items.pick_from_gallery';
  static const String items_edit = 'items.edit';
  static const String items_delete = 'items.delete';
  static const String items_addCategory = 'items.add_category';
  static const String items_editCategory = 'items.edit_category';
  static const String items_categoryNameHint = 'items.category_name_hint';
  static const String items_categoriesEmpty = 'items.categories_empty';
  static const String items_deleteCategoryTitle = 'items.delete_category_title';
  static const String items_deleteCategoryMessage =
      'items.delete_category_message';
  static const String items_itemsCount = 'items.items_count';
  static const String items_addItem = 'items.add_item';
  static const String items_editItem = 'items.edit_item';
  static const String items_itemNameHint = 'items.item_name_hint';
  static const String items_itemPriceHint = 'items.item_price_hint';
  static const String items_priceInvalid = 'items.price_invalid';
  static const String items_itemsEmpty = 'items.items_empty';
  static const String items_deleteItemTitle = 'items.delete_item_title';
  static const String items_deleteItemMessage = 'items.delete_item_message';

  // ─── Orders ───────────────────────────────────────────────────────────────
  static const String orders_searchHint = 'orders.search_hint';
  static const String orders_tableDetails = 'orders.table_details';
  static const String orders_noSearchResults = 'orders.no_search_results';
  static const String orders_total = 'orders.total';
  static const String orders_back = 'orders.back';
  static const String orders_partialPay = 'orders.partial_pay';
  static const String orders_payFull = 'orders.pay_full';
  static const String orders_cancelOrder = 'orders.cancel_order';
  static const String orders_defer = 'orders.defer';
  static const String orders_empty = 'orders.empty';
  static const String orders_cancelTitle = 'orders.cancel_title';
  static const String orders_cancelMessage = 'orders.cancel_message';
  static const String orders_cancelConfirm = 'orders.cancel_confirm';
  static const String orders_cancelReasonLabel = 'orders.cancel_reason_label';
  static const String orders_cancelledBadge = 'orders.cancelled_badge';
  static const String orders_cancelledFromDeferred =
      'orders.cancelled_from_deferred';
  static const String orders_paymentMethodTitle = 'orders.payment_method_title';
  static const String orders_cash = 'orders.cash';
  static const String orders_wallet = 'orders.wallet';
  static const String orders_selectItemsHint = 'orders.select_items_hint';
  static const String orders_selectedTotal = 'orders.selected_total';
  static const String orders_payButton = 'orders.pay_button';
  static const String orders_selectAtLeastOneItem =
      'orders.select_at_least_one_item';
  static const String orders_partialPayResultTitle =
      'orders.partial_pay_result_title';
  static const String orders_partialPayResultMessage =
      'orders.partial_pay_result_message';
  static const String orders_keepOpenOption = 'orders.keep_open_option';
  static const String orders_deferRemainderOption =
      'orders.defer_remainder_option';
  static const String orders_confirmPaymentTitle =
      'orders.confirm_payment_title';
  static const String orders_confirmPaymentMessage =
      'orders.confirm_payment_message';
  static const String orders_confirmPartialPaymentMessage =
      'orders.confirm_partial_payment_message';
  static const String orders_changePaymentMethod =
      'orders.change_payment_method';

  // ─── Customers ────────────────────────────────────────────────────────────
  static const String customers_addCustomer = 'customers.add_customer';
  static const String customers_editCustomer = 'customers.edit_customer';
  static const String customers_searchHint = 'customers.search_hint';
  static const String customers_filterTitle = 'customers.filter_title';
  static const String customers_sortNameAsc = 'customers.sort_name_asc';
  static const String customers_sortNameDesc = 'customers.sort_name_desc';
  static const String customers_sortNewest = 'customers.sort_newest';
  static const String customers_sortOldest = 'customers.sort_oldest';
  static const String customers_empty = 'customers.empty';
  static const String customers_deleteTitle = 'customers.delete_title';
  static const String customers_deleteMessage = 'customers.delete_message';
  static const String customers_phoneExists = 'customers.phone_exists';
  static const String customers_pickerTitle = 'customers.picker_title';
  static const String customers_cashierLabel = 'customers.cashier_label';
  static const String customers_collectAction = 'customers.collect_action';
  static const String customers_writeOffAction = 'customers.write_off_action';
  static const String customers_writeOffTitle = 'customers.write_off_title';
  static const String customers_writeOffMessage = 'customers.write_off_message';
  static const String customers_totalOwed = 'customers.total_owed';
  static const String customers_noDeferredOrders =
      'customers.no_deferred_orders';
  static const String customers_noDeferredAccounts =
      'customers.no_deferred_accounts';
  static const String customers_deferredOrdersCount =
      'customers.deferred_orders_count';
  static const String customers_viewDeferredOrders =
      'customers.view_deferred_orders';
  static const String customers_confirmEditTitle =
      'customers.confirm_edit_title';
  static const String customers_confirmEditMessage =
      'customers.confirm_edit_message';

  // ─── Employees ────────────────────────────────────────────────────────────
  static const String employees_addEmployee = 'employees.add_employee';
  static const String employees_editEmployee = 'employees.edit_employee';
  static const String employees_empty = 'employees.empty';
  static const String employees_deleteTitle = 'employees.delete_title';
  static const String employees_deleteMessage = 'employees.delete_message';
  static const String employees_statusActive = 'employees.status_active';
  static const String employees_statusInactive = 'employees.status_inactive';

  // ─── Guest ────────────────────────────────────────────────────────────────
  static const String guest_lockTitle = 'guest.lock_title';
  static const String guest_lockMessage = 'guest.lock_message';
  static const String guest_dialogTitle = 'guest.dialog_title';
  static const String guest_dialogMessage = 'guest.dialog_message';
  static const String guest_dialogConfirm = 'guest.dialog_confirm';

  // ─── Errors ───────────────────────────────────────────────────────────────
  static const String error_unauthorized = 'error.unauthorized';
  static const String error_notFound = 'error.not_found';

  // ─── Sync ─────────────────────────────────────────────────────────────────
  static const String sync_downloadPromptTitle = 'sync.download_prompt_title';
  static const String sync_downloadPromptMessage =
      'sync.download_prompt_message';
  static const String sync_downloadNow = 'sync.download_now';
  static const String sync_skip = 'sync.skip';
  static const String sync_uploadPromptTitle = 'sync.upload_prompt_title';
  static const String sync_uploadPromptMessage = 'sync.upload_prompt_message';
  static const String sync_uploadNow = 'sync.upload_now';
  static const String sync_uploadSuccess = 'sync.upload_success';
  static const String sync_uploadFailed = 'sync.upload_failed';
  static const String sync_noInternetTitle = 'sync.no_internet_title';
  static const String sync_noInternetForUploadMessage =
      'sync.no_internet_for_upload_message';
  static const String sync_retryUpload = 'sync.retry_upload';
  static const String sync_preparing = 'sync.preparing';
  static const String sync_compressing = 'sync.compressing';
  static const String sync_zippingImages = 'sync.zipping_images';
  static const String sync_uploading = 'sync.uploading';
  static const String sync_downloading = 'sync.downloading';
  static const String sync_merging = 'sync.merging';
  static const String sync_ofBytes = 'sync.of_bytes';
  static const String sync_etaLabel = 'sync.eta_label';
  static const String sync_syncedBadge = 'sync.synced_badge';
  static const String sync_notSyncedBadge = 'sync.not_synced_badge';
  static const String sync_downloadSuccess = 'sync.download_success';
  static const String sync_downloadFailed = 'sync.download_failed';
  static const String sync_conflictTitle = 'sync.conflict_title';
  static const String sync_conflictSubtitle = 'sync.conflict_subtitle';
  static const String sync_conflictLocal = 'sync.conflict_local';
  static const String sync_conflictServer = 'sync.conflict_server';
  static const String sync_conflictTakeServer = 'sync.conflict_take_server';
  static const String sync_conflictKeepLocal = 'sync.conflict_keep_local';
  static const String sync_conflictAllServer = 'sync.conflict_all_server';
  static const String sync_conflictAllLocal = 'sync.conflict_all_local';
  static const String sync_conflictApply = 'sync.conflict_apply';
  static const String sync_conflictDeletedRemotely =
      'sync.conflict_deleted_remotely';
  static const String sync_conflictDelete = 'sync.conflict_delete';
  static const String sync_conflictKeep = 'sync.conflict_keep';
  static const String sync_conflictTypeCategory = 'sync.conflict_type_category';
  static const String sync_conflictTypeItem = 'sync.conflict_type_item';
  static const String sync_conflictTypeCustomer = 'sync.conflict_type_customer';
  static const String sync_conflictFieldName = 'sync.conflict_field_name';
  static const String sync_conflictFieldPrice = 'sync.conflict_field_price';
  static const String sync_conflictFieldOrder = 'sync.conflict_field_order';
  static const String sync_conflictFieldPhone = 'sync.conflict_field_phone';
  static const String sync_loginNeedsInternetTitle =
      'sync.login_needs_internet_title';
  static const String sync_loginNeedsInternetMessage =
      'sync.login_needs_internet_message';
  static const String sync_loginSyncFailedTitle =
      'sync.login_sync_failed_title';
  static const String sync_loginSyncFailedMessage =
      'sync.login_sync_failed_message';
  static const String sync_retry = 'sync.retry';
  static const String sync_cancelLogin = 'sync.cancel_login';
  static const String sync_shiftClosedOfflinePendingUpload =
      'sync.shift_closed_offline_pending_upload';
}
