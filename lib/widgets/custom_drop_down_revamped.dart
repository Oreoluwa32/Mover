import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomDropDownRevamped extends StatefulWidget {
  final String? value;
  final String hintText;
  final List<String> items;
  final Function(String)? onChanged;
  final Widget? prefixIcon;

  const CustomDropDownRevamped({
    Key? key,
    this.value,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.prefixIcon,
  }) : super(key: key);

  @override
  _CustomDropDownRevampedState createState() => _CustomDropDownRevampedState();
}

class _CustomDropDownRevampedState extends State<CustomDropDownRevamped> {
  bool isExpanded = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _toggleOverlay() {
    if (isExpanded) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _removeOverlay,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 8.h),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12.h),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 250.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.h),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.h),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = widget.value == item;
                        return InkWell(
                          onTap: () {
                            widget.onChanged?.call(item);
                            _removeOverlay();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
                            color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.05) : Colors.white,
                            child: Row(
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 16.fSize,
                                    color: isSelected ? theme.colorScheme.primary : Colors.grey.shade700,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    setState(() {
      isExpanded = true;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        isExpanded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the border color based on focus/expansion or having a value
    final bool isActive = isExpanded || widget.value != null;
    final Color borderColor = isActive ? theme.colorScheme.primary : appTheme.gray400;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.h),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              if (widget.prefixIcon != null) ...[
                widget.prefixIcon!,
                SizedBox(width: 12.h),
              ],
              Expanded(
                child: Text(
                  widget.value ?? widget.hintText,
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w500,
                    color: widget.value != null ? Colors.black : Colors.black54,
                  ),
                ),
              ),
              Icon(
                isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.blueGrey,
                size: 24.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
