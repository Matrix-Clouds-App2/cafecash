import 'package:flutter/material.dart';

class CustomReorderableGridView extends StatelessWidget {
  const CustomReorderableGridView({
    super.key,
    required this.itemCount,
    required this.gridDelegate,
    required this.itemBuilder,
    required this.onReorder,
    this.padding,
    this.physics,
  });

  final int itemCount;
  final SliverGridDelegate gridDelegate;
  final Widget Function(BuildContext context, int index) itemBuilder;

  final void Function(int oldIndex, int newIndex) onReorder;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      physics: physics,
      gridDelegate: gridDelegate,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final child = itemBuilder(context, index);

        return LayoutBuilder(
          builder: (context, constraints) {
            final cellSize = Size(constraints.maxWidth, constraints.maxHeight);

            return DragTarget<int>(
              onWillAcceptWithDetails: (details) => details.data != index,
              onAcceptWithDetails: (details) => onReorder(details.data, index),
              builder: (context, candidateData, rejectedData) {
                final isTargeted = candidateData.isNotEmpty;

                return AnimatedScale(
                  scale: isTargeted ? 1.05 : 1,
                  duration: const Duration(milliseconds: 150),
                  child: LongPressDraggable<int>(
                    data: index,
                    feedback: SizedBox.fromSize(
                      size: cellSize,
                      child: Material(
                        color: Colors.transparent,
                        elevation: 6,
                        borderRadius: BorderRadius.circular(12),
                        child: Opacity(opacity: 0.9, child: child),
                      ),
                    ),
                    childWhenDragging: Opacity(opacity: 0.3, child: child),
                    child: child,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
