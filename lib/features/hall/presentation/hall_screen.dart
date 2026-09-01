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
import '../../../core/widgets/watermark_background.dart';
import '../../orders/data/models/order_location_kind.dart';
import '../../orders/data/orders_repo.dart';
import '../../orders/presentation/widgets/order_builder_sheet.dart';
import '../data/hall_repo.dart';
import '../data/models/hall_table_entity.dart';
import '../logic/hall_cubit.dart';
import 'widgets/hall_add_table_card.dart';
import 'widgets/hall_filter_sheet.dart';
import 'widgets/hall_settings_sheet.dart';
import 'widgets/hall_table_card.dart';

class HallScreen extends StatefulWidget {
  const HallScreen({super.key});

  @override
  State<HallScreen> createState() => _HallScreenState();
}

class _HallScreenState extends State<HallScreen>
    with SingleTickerProviderStateMixin {
  static const double _cardWidth = 104;
  static const double _cardAspectRatio = 0.72;

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
    _columns = getIt<LocalStorage>().getHallColumns();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _snapController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _toggleSearch(HallCubit cubit) {
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
      create: (_) => getIt<HallCubit>()..fetchTables(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<HallCubit>();

          return Scaffold(
            backgroundColor: AppColors.surfaceColor.themeColor,
            body: WatermarkBackground(
              child: Column(
                children: [
                  AppTopBar(
                    title: LocaleKeys.nav_hall.tr(),
                    onMenuTap: () => Scaffold.of(context).openDrawer(),
                    titleWidget: _isSearching
                        ? CustomSearchField(
                            controller: _searchCtrl,
                            onChanged: cubit.search,
                            hintText: LocaleKeys.hall_searchHint.tr(),
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
                          HallFilterSheet.show(
                            context,
                            initialSort: state is HallSuccess
                                ? state.sort
                                : HallSortOption.numberAsc,
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
                          HallSettingsSheet.show(
                            context,
                            initialColumns: _columns,
                            onApply: (value) async {
                              setState(() {
                                _columns = value;
                                _didPositionBoard = false;
                              });
                              await getIt<LocalStorage>().setHallColumns(value);
                            },
                          );
                        },
                        child: Icon(
                          Icons.settings_outlined,
                          size: 22.sp,
                          color: AppColors.textPrimaryColor.themeColor,
                        ),
                      ),
                      // 12.width,
                      // const NotificationBellIcon(),
                    ],
                  ),
                  Expanded(
                    child: BlocBuilder<HallCubit, HallState>(
                      builder: (context, state) {
                        if (state is HallLoading || state is HallInitial) {
                          return Center(
                            child: CustomLoadingWidget(
                              color: AppColors.primaryColor.themeColor,
                              size: 40,
                            ),
                          );
                        }

                        if (state is HallError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }

                        final tables = (state as HallSuccess).tables;
                        final itemCount = tables.length + 1;
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
                                if (mounted) _positionBoard(1.0);
                              });
                            }

                            final fillerHeight = math.max(
                              0.0,
                              constraints.biggest.height - gridHeight - 32.h,
                            );

                            return InteractiveViewer(
                              transformationController:
                                  _transformationController,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          if (i == tables.length) {
                                            return AnimatedGridItem(
                                              key: const ValueKey(
                                                  'hall_add_table'),
                                              index: i,
                                              child: HallAddTableCard(
                                                  onTap: cubit.addTable),
                                            );
                                          }
                                          final table = tables[i];
                                          return AnimatedGridItem(
                                            key: ValueKey(table.id),
                                            index: i,
                                            child: HallTableCard(
                                              table: table,
                                              onDisable: () =>
                                                  cubit.toggleStatus(table),
                                              onReactivate: () =>
                                                  cubit.toggleStatus(table),
                                              onDelete: () =>
                                                  cubit.deleteTable(table),
                                              canDelete:
                                                  cubit.isLastTable(table),
                                              onCancelOrder: (reason) {
                                                final ordersRepo =
                                                    getIt<OrdersRepo>();
                                                final order =
                                                    ordersRepo.getActiveOrder(
                                                  table.id,
                                                  OrderLocationKind.table,
                                                );
                                                if (order != null) {
                                                  ordersRepo.cancel(order,
                                                      reason: reason);
                                                }
                                                getIt<HallRepo>()
                                                    .syncOrderSummary(
                                                  tableId: table.id,
                                                  status:
                                                      HallTableStatus.available,
                                                );
                                              },
                                              onOpenOrder: () =>
                                                  OrderBuilderSheet.show(
                                                context,
                                                locationId: table.id,
                                                locationNumber: table.number,
                                                kind: OrderLocationKind.table,
                                                locationLabel: LocaleKeys
                                                    .hall_tableLabel
                                                    .tr(),
                                                syncStatus: ({
                                                  required occupied,
                                                  drinkCount = 0,
                                                  price = 0,
                                                }) =>
                                                    getIt<HallRepo>()
                                                        .syncOrderSummary(
                                                  tableId: table.id,
                                                  status: occupied
                                                      ? HallTableStatus.occupied
                                                      : HallTableStatus
                                                          .available,
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
            ),
          );
        },
      ),
    );
  }
}
