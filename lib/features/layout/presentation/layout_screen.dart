import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../hall/presentation/hall_screen.dart';
import '../../matches/presentation/matches_screen.dart';
import '../../payments/presentation/payments_screen.dart';
import '../../shift/logic/shift_cubit.dart';
import '../../shift/presentation/widgets/shift_start_view.dart';
import '../../treasury/presentation/treasury_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key, this.currentPage = 0});

  final int currentPage;

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late int _currentIndex;

  static const _screens = [
    HallScreen(),
    MatchesScreen(),
    PaymentsScreen(),
    TreasuryScreen(),
  ];

  static const _navItems = [
    NavBarItem(labelKey: LocaleKeys.nav_hall, icon: Icons.table_bar_rounded),
    NavBarItem(
        labelKey: LocaleKeys.nav_matches, icon: Icons.sports_soccer_rounded),
    NavBarItem(
        labelKey: LocaleKeys.nav_payments, icon: Icons.payments_outlined),
    NavBarItem(
        labelKey: LocaleKeys.nav_treasury,
        icon: Icons.account_balance_wallet_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftCubit, ShiftState>(
      builder: (context, state) {
        final hasActiveShift = state is ShiftReady && state.active != null;

        return Scaffold(
          backgroundColor: AppColors.backgroundColor.themeColor,
          drawer: const AppDrawer(),
          body: Builder(
            builder: (context) {
              if (state is ShiftReady) {
                if (hasActiveShift) {
                  return IndexedStack(index: _currentIndex, children: _screens);
                }
                return Column(
                  children: [
                    AppTopBar(
                      title: LocaleKeys.shift_title.tr(),
                      onMenuTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    const Expanded(child: ShiftStartView()),
                  ],
                );
              }

              return Column(
                children: [
                  AppTopBar(
                    title: LocaleKeys.shift_title.tr(),
                    onMenuTap: () => Scaffold.of(context).openDrawer(),
                  ),
                  Expanded(
                    child: Center(
                      child: CustomLoadingWidget(
                        color: AppColors.primaryColor.themeColor,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: hasActiveShift
              ? CoffeeCashNavBar(
                  items: _navItems,
                  currentIndex: _currentIndex,
                  onTap: (i) => setState(() => _currentIndex = i),
                )
              : null,
        );
      },
    );
  }
}
