import 'package:flutter/material.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/customers/data/models/customer_entity.dart';
import '../../features/customers/presentation/customer_deferred_orders_screen.dart';
import '../../features/customers/presentation/customers_screen.dart';
import '../../features/customers/presentation/deferred_accounts_screen.dart';
import '../../features/items/data/models/category_entity.dart';
import '../../features/items/presentation/categories_screen.dart';
import '../../features/items/presentation/menu_items_screen.dart';
import '../../features/layout/presentation/layout_screen.dart';
import '../../features/more/presentation/more_screen.dart';
import '../../features/orders/data/models/order_entity.dart';
import '../../features/orders/data/models/order_location_kind.dart';
import '../../features/orders/logic/order_cubit.dart';
import '../../features/orders/presentation/order_details_screen.dart';
import '../../features/orders/presentation/partial_pay_screen.dart';
import '../../features/payments/presentation/paid_order_details_screen.dart';
import '../../features/settings/presentation/about_us_screen.dart';
import '../../features/settings/presentation/privacy_policy_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/terms_conditions_screen.dart';
import '../../features/shift/data/models/shift_entity.dart';
import '../../features/shift/presentation/cancelled_order_details_screen.dart';
import '../../features/shift/presentation/shift_cancelled_orders_screen.dart';
import '../../features/shift/presentation/shift_history_screen.dart';
import '../../features/shift/presentation/shift_orders_screen.dart';
import '../../features/shift/presentation/shift_start_screen.dart';
import '../../features/shift/presentation/shift_summary_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/treasury/presentation/treasury_entry_screen.dart';
import '../../features/treasury/presentation/treasury_transactions_screen.dart';
import 'routes.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splashScreen:
        return _pageRoute(const SplashScreen());

      case Routes.loginScreen:
        return _pageRoute(const LoginScreen());

      case Routes.registerScreen:
        return _pageRoute(const RegisterScreen());

      case Routes.otpScreen:
        return _pageRoute(OtpScreen(phone: arguments?['phone'] ?? ''));

      case Routes.layoutScreen:
        return _pageRoute(LayoutScreen(
          currentPage: arguments?['currentPage'] ?? 0,
        ));

      case Routes.shiftStartScreen:
        return _pageRoute(const ShiftStartScreen());

      case Routes.categoriesScreen:
        return _pageRoute(const CategoriesScreen());

      case Routes.menuItemsScreen:
        return _pageRoute(MenuItemsScreen(
          category: arguments!['category'] as CategoryEntity,
        ));

      case Routes.moreScreen:
        return _pageRoute(const MoreScreen());

      case Routes.orderDetailsScreen:
        return _pageRoute(OrderDetailsScreen(
          locationId: arguments!['locationId'] as int,
          locationNumber: arguments['locationNumber'] as int,
          kind: arguments['kind'] as OrderLocationKind,
          locationLabel: arguments['locationLabel'] as String,
          syncStatus: arguments['syncStatus'] as LocationStatusSync,
        ));

      case Routes.paidOrderDetailsScreen:
        return _pageRoute(PaidOrderDetailsScreen(
          order: arguments!['order'] as OrderEntity,
        ));

      case Routes.shiftHistoryScreen:
        return _pageRoute(const ShiftHistoryScreen());

      case Routes.shiftSummaryScreen:
        return _pageRoute(ShiftSummaryScreen(
          shift: arguments!['shift'] as ShiftEntity,
        ));

      case Routes.shiftOrdersScreen:
        return _pageRoute(ShiftOrdersScreen(
          shift: arguments!['shift'] as ShiftEntity,
        ));

      case Routes.treasuryEntryScreen:
        return _pageRoute(TreasuryEntryScreen(
          isIncome: arguments!['isIncome'] as bool,
        ));

      case Routes.treasuryTransactionsScreen:
        return _pageRoute(TreasuryTransactionsScreen(
          isIncome: arguments?['isIncome'] as bool?,
          paymentMethod: arguments?['paymentMethod'] as PaymentMethod?,
          shift: arguments?['shift'] as ShiftEntity?,
        ));

      case Routes.customersScreen:
        return _pageRoute(const CustomersScreen());

      case Routes.partialPayScreen:
        return _pageRoute(PartialPayScreen(
          cubit: arguments!['cubit'] as OrderCubit,
        ));

      case Routes.customerDeferredOrdersScreen:
        return _pageRoute(CustomerDeferredOrdersScreen(
          customer: arguments!['customer'] as CustomerEntity,
        ));

      case Routes.deferredAccountsScreen:
        return _pageRoute(const DeferredAccountsScreen());

      case Routes.shiftCancelledOrdersScreen:
        return _pageRoute(ShiftCancelledOrdersScreen(
          shift: arguments!['shift'] as ShiftEntity,
        ));

      case Routes.cancelledOrderDetailsScreen:
        return _pageRoute(CancelledOrderDetailsScreen(
          order: arguments!['order'] as OrderEntity,
        ));

      case Routes.settingsScreen:
        return _pageRoute(const SettingsScreen());

      case Routes.termsConditionsScreen:
        return _pageRoute(const TermsConditionsScreen());

      case Routes.aboutUsScreen:
        return _pageRoute(const AboutUsScreen());

      case Routes.privacyPolicyScreen:
        return _pageRoute(const PrivacyPolicyScreen());

      default:
        return _pageRoute(const _UndefinedScreen());
    }
  }

  static PageRoute<dynamic> _pageRoute(Widget page) {
    return MaterialPageRoute(builder: (_) => page);
  }
}

class _UndefinedScreen extends StatelessWidget {
  const _UndefinedScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page not found')),
    );
  }
}
