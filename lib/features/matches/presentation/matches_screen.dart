import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/animated_grid_item.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/notification_bell_icon.dart';
import '../../../core/widgets/search_field.dart';
import '../../orders/data/models/order_location_kind.dart';
import '../../orders/data/orders_repo.dart';
import '../../orders/presentation/widgets/order_builder_sheet.dart';
import '../data/matches_repo.dart';
import '../data/models/match_seat_entity.dart';
import '../logic/matches_cubit.dart';
import 'widgets/matches_add_seat_card.dart';
import 'widgets/matches_filter_sheet.dart';
import 'widgets/matches_seat_card.dart';
import 'widgets/matches_settings_sheet.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  static const double _cardWidth = 132;
  static const double _cardAspectRatio = 0.8;

  static const double _absoluteFloorScale = 0.05;
  static const double _maxZoomScale = 2.5;

  static const double _fitScreenMargin = 24;

  final _searchCtrl = TextEditingController();
  final _transformationController = TransformationController();
  final _boardKey = GlobalKey();
  bool _isSearching = false;
  bool _didPositionBoard = false;
  Size? _viewportSize;
  double _fitScale = 1.0;
  late int _columns;

  late final _snapController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  )..addListener(() {
      final animation = _snapAnimation;
      if (animation != null) _transformationController.value = animation.value;
    });
  Animation<Matrix4>? _snapAnimation;

  @override
  void initState() {
    super.initState();
    _columns = getIt<LocalStorage>().getMatchesColumns();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _snapController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleSearch(MatchesCubit cubit) {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching) {
      _searchCtrl.clear();
      cubit.search('');
    }
  }

  Matrix4? _matrixFor(double scale) {
    final renderBox =
        _boardKey.currentContext?.findRenderObject() as RenderBox?;
    final viewport = _viewportSize;
    if (renderBox == null || !renderBox.hasSize || viewport == null) {
      return null;
    }

    final content = renderBox.size;
    if (content.width == 0 || content.height == 0) return null;

    final dx = (viewport.width - content.width * scale) / 2;
    return Matrix4.identity()
      ..translateByDouble(dx, 0, 0, 1)
      ..scaleByDouble(scale, scale, scale, 1);
  }

  void _positionBoard(double scale) {
    final matrix = _matrixFor(scale);
    if (matrix != null) _transformationController.value = matrix;
  }

  void _fitToScreen() {
    final target = _matrixFor(_fitScale);
    if (target == null) return;
    _snapAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: target,
    ).animate(
        CurvedAnimation(parent: _snapController, curve: Curves.easeOutCubic));
    _snapController.forward(from: 0);
  }

  void _maybeSnapToFit() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale <= _fitScale + 0.01) _fitToScreen();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MatchesCubit>()..fetchSeats(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<MatchesCubit>();

          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            body: Column(
              children: [
                AppTopBar(
                  title: LocaleKeys.nav_matches.tr(),
                  onMenuTap: () => Scaffold.of(context).openDrawer(),
                  titleWidget: _isSearching
                      ? CustomSearchField(
                          controller: _searchCtrl,
                          onChanged: cubit.search,
                          hintText: LocaleKeys.matches_searchHint.tr(),
                        )
                      : null,
                  actions: [
                    GestureDetector(
                      onTap: () => _toggleSearch(cubit),
                      child: Icon(
                        _isSearching
                            ? Icons.close_rounded
                            : Icons.search_rounded,
                        size: 22.sp,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                    ),
                    12.width,
                    GestureDetector(
                      onTap: _fitToScreen,
                      child: Icon(
                        Icons.fit_screen_rounded,
                        size: 22.sp,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                    ),
                    12.width,
                    GestureDetector(
                      onTap: () {
                        final state = cubit.state;
                        MatchesFilterSheet.show(
                          context,
                          initialSort: state is MatchesSuccess
                              ? state.sort
                              : MatchesSortOption.numberAsc,
                          onApply: cubit.sort,
                        );
                      },
                      child: Icon(
                        Icons.filter_list_rounded,
                        size: 22.sp,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                    ),
                    12.width,
                    GestureDetector(
                      onTap: () {
                        MatchesSettingsSheet.show(
                          context,
                          initialColumns: _columns,
                          onApply: (value) async {
                            setState(() {
                              _columns = value;
                              _didPositionBoard = false;
                            });
                            await getIt<LocalStorage>()
                                .setMatchesColumns(value);
                          },
                        );
                      },
                      child: Icon(
                        Icons.settings_outlined,
                        size: 22.sp,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                    ),
                    12.width,
                    const NotificationBellIcon(),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<MatchesCubit, MatchesState>(
                    builder: (context, state) {
                      if (state is MatchesLoading || state is MatchesInitial) {
                        return Center(
                          child: CustomLoadingWidget(
                            color: AppColors.primaryColor.themeColor,
                            size: 40,
                          ),
                        );
                      }

                      if (state is MatchesError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }

                      final seats = (state as MatchesSuccess).seats;
                      final itemCount = seats.length + 1;
                      final crossSpacing = 12.w;
                      final gridWidth = _columns * _cardWidth.w +
                          (_columns - 1) * crossSpacing;
                      final rows = (itemCount / _columns).ceil();
                      final cellHeight = _cardWidth.w / _cardAspectRatio;
                      final gridHeight =
                          rows * cellHeight + math.max(0, rows - 1) * 12.h;

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          _viewportSize = constraints.biggest;

                          final boardWidth = gridWidth + 32.w;
                          final boardHeight = gridHeight + 32.h;
                          _fitScale = math
                              .min(
                                (constraints.biggest.width -
                                        _fitScreenMargin.w * 2) /
                                    boardWidth,
                                (constraints.biggest.height -
                                        _fitScreenMargin.h * 2) /
                                    boardHeight,
                              )
                              .clamp(_absoluteFloorScale, 1.0);

                          if (!_didPositionBoard) {
                            _didPositionBoard = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) _positionBoard(_fitScale);
                            });
                          }

                          final fillerHeight = math.max(
                            0.0,
                            constraints.biggest.height - gridHeight - 32.h,
                          );

                          return InteractiveViewer(
                            transformationController: _transformationController,
                            constrained: false,
                            onInteractionEnd: (_) => _maybeSnapToFit(),
                            boundaryMargin: EdgeInsets.all(24.w),
                            minScale: _fitScale,
                            maxScale: _maxZoomScale,
                            child: Padding(
                              key: _boardKey,
                              padding: 16.paddingAll,
                              child: SizedBox(
                                width: gridWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: itemCount,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: _columns,
                                        crossAxisSpacing: crossSpacing,
                                        mainAxisSpacing: 12.h,
                                        childAspectRatio: _cardAspectRatio,
                                      ),
                                      itemBuilder: (_, i) {
                                        if (i == seats.length) {
                                          return AnimatedGridItem(
                                            key: const ValueKey(
                                                'matches_add_seat'),
                                            index: i,
                                            child: MatchesAddSeatCard(
                                                onTap: cubit.addSeat),
                                          );
                                        }
                                        final seat = seats[i];
                                        return AnimatedGridItem(
                                          key: ValueKey(seat.id),
                                          index: i,
                                          child: MatchesSeatCard(
                                            seat: seat,
                                            onDisable: () =>
                                                cubit.toggleStatus(seat),
                                            onReactivate: () =>
                                                cubit.toggleStatus(seat),
                                            onDelete: () =>
                                                cubit.deleteSeat(seat),
                                            canDelete: cubit.isLastSeat(seat),
                                            onCancelOrder: (reason) {
                                              final ordersRepo =
                                                  getIt<OrdersRepo>();
                                              final order =
                                                  ordersRepo.getActiveOrder(
                                                seat.id,
                                                OrderLocationKind.seat,
                                              );
                                              if (order != null) {
                                                ordersRepo.cancel(order,
                                                    reason: reason);
                                              }
                                              getIt<MatchesRepo>()
                                                  .syncOrderSummary(
                                                seatId: seat.id,
                                                status:
                                                    MatchSeatStatus.available,
                                              );
                                            },
                                            onOpenOrder: () =>
                                                OrderBuilderSheet.show(
                                              context,
                                              locationId: seat.id,
                                              locationNumber: seat.number,
                                              kind: OrderLocationKind.seat,
                                              locationLabel: LocaleKeys
                                                  .matches_seatLabel
                                                  .tr(),
                                              syncStatus: ({
                                                required occupied,
                                                drinkCount = 0,
                                                price = 0,
                                              }) =>
                                                  getIt<MatchesRepo>()
                                                      .syncOrderSummary(
                                                seatId: seat.id,
                                                status: occupied
                                                    ? MatchSeatStatus.occupied
                                                    : MatchSeatStatus.available,
                                                drinkCount: drinkCount,
                                                price: price,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: fillerHeight),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
