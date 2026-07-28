import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';

class ExpandableHtml extends StatefulWidget {
  const ExpandableHtml({
    super.key,
    required this.data,
    this.collapsedLines = 6,
    this.fadeColor = Colors.white,
    this.extraStyle,
  });

  final String data;
  final int collapsedLines;
  final Color fadeColor;
  final Map<String, Style>? extraStyle;

  @override
  State<ExpandableHtml> createState() => _ExpandableHtmlState();
}

class _ExpandableHtmlState extends State<ExpandableHtml>
    with AutomaticKeepAliveClientMixin {
  bool _expanded = false;
  bool? _overflows;
  final _ghostKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_measure);
  }

  void _measure(Duration _) {
    final box = _ghostKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || !mounted) return;
    final threshold = _collapsedHeight;
    setState(() => _overflows = box.size.height > threshold + 2);
  }

  double get _collapsedHeight =>
      13.0.sp * 1.3 * widget.collapsedLines + 10.0;

  Map<String, Style> get _style => {
        'html': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        // 'body': Style(
        //   margin: Margins.zero,
        //   padding: HtmlPaddings.zero,
        //   fontSize: FontSize(13.sp),
        //   fontWeight: FontWeight.w300,
        //   color: Colors.grey.shade700,
        //   lineHeight: const LineHeight(1.3),
        //   fontFamily: 'Cairo',
        // ),
        // 'table': Style(
        //   border: Border.all(color: Colors.grey.shade300, width: 0.8),
        // ),
        // 'th': Style(
        //   padding: HtmlPaddings.all(8),
        //   backgroundColor: Colors.grey.shade100,
        //   fontWeight: FontWeight.w700,
        // ),
        // 'td': Style(
        //   padding: HtmlPaddings.all(8),
        //   border: Border.all(color: Colors.grey.shade300, width: 0.6),
        // ),
        ...?widget.extraStyle,
      };

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final primary = AppColors.primaryColor.themeColor;
    final collapsedH = _collapsedHeight;
    // Start collapsed while measuring; expand only when confirmed not overflowing.
    final showFull = _expanded || _overflows == false;

    return LayoutBuilder(
      builder: (context, constraints) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Invisible ghost — renders at full height inside a 0-height box
          // so we can measure the real content height without a visible flash.
          if (_overflows == null)
            SizedBox(
              height: 0,
              child: Opacity(
                opacity: 0,
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  maxHeight: double.infinity,
                  maxWidth: constraints.maxWidth,
                  child: Html(
                    key: _ghostKey,
                    data: widget.data,
                    style: _style,
                  ),
                ),
              ),
            ),

          Stack(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: ClipRect(
                  child: SizedBox(
                    height: showFull ? null : collapsedH,
                    child: Html(data: widget.data, style: _style),
                  ),
                ),
              ),
              if (!showFull)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          widget.fadeColor.withValues(alpha: 0),
                          widget.fadeColor,
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),

          if (_overflows == true)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _expanded ? 'أقل' : 'المزيد',
                      style: TextStyle(
                        color: primary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: primary,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
