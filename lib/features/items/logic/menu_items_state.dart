part of 'menu_items_cubit.dart';

sealed class MenuItemsState extends Equatable {
  const MenuItemsState();

  @override
  List<Object?> get props => [];
}

final class MenuItemsInitial extends MenuItemsState {
  const MenuItemsInitial();
}

final class MenuItemsLoading extends MenuItemsState {
  const MenuItemsLoading();
}

final class MenuItemsSuccess extends MenuItemsState {
  final List<MenuItemEntity> items;

  const MenuItemsSuccess(this.items);

  @override
  List<Object?> get props => [items];
}

final class MenuItemsError extends MenuItemsState {
  final String message;

  const MenuItemsError(this.message);

  @override
  List<Object?> get props => [message];
}
