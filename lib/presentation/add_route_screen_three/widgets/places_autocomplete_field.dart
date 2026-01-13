import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_radio_button.dart';
import '../notifier/add_route_two_notifier.dart';
import '../notifier/places_autocomplete_notifier.dart';

class PlacesAutocompleteField extends ConsumerStatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String radioValue;
  final VoidCallback onRadioChange;
  final Function(String description, double lat, double lng)? onPlaceSelected;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final String? prefix;

  const PlacesAutocompleteField({
    this.controller,
    required this.hintText,
    required this.radioValue,
    required this.onRadioChange,
    this.onPlaceSelected,
    this.showCloseButton = false,
    this.onClose,
    this.prefix,
    super.key,
  });

  @override
  ConsumerState<PlacesAutocompleteField> createState() =>
      _PlacesAutocompleteFieldState();
}

class _PlacesAutocompleteFieldState
    extends ConsumerState<PlacesAutocompleteField> {
  late FocusNode _focusNode;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        ref.read(placesAutocompleteProvider.notifier).closeSuggestions();
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    }
  }

  void _showOverlay() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, size.height + 5),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              child: Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(placesAutocompleteProvider);
                  print('Places Overlay - Showing: ${state.showSuggestions}, Predictions: ${state.predictions.length}, Error: ${state.error}');
                  if (!state.showSuggestions || state.predictions.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    constraints: BoxConstraints(maxHeight: 300.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: state.predictions.length,
                      itemBuilder: (context, index) {
                        final prediction = state.predictions[index];
                        return ListTile(
                          dense: true,
                          title: Text(
                            prediction.mainText,
                            style: CustomTextStyles.bodySmallGray80001,
                          ),
                          subtitle: Text(
                            prediction.secondaryText,
                            style: CustomTextStyles.bodySmallGray80001?.copyWith(
                              color: appTheme.gray600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            ref
                                .read(placesAutocompleteProvider.notifier)
                                .selectPlace(prediction);
                            widget.controller?.text = prediction.description;
                            _focusNode.unfocus();
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(addRouteTwoNotifier);
        return CompositedTransformTarget(
          link: _layerLink,
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            onChanged: (value) {
              try {
                ref
                    .read(placesAutocompleteProvider.notifier)
                    .searchPlaces(value);
              } catch (e) {
                print('Error in searchPlaces: $e');
              }
            },
            onTap: () {
              widget.onRadioChange();
            },
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: CustomTextStyles.bodyMediumBluegray400,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appTheme.gray20001,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: appTheme.gray20001,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1,
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 8.h, right: 8.h),
                child: CustomRadioButton(
                  value: widget.radioValue,
                  groupValue: state.radioGroup,
                  onChange: (value) {
                    widget.onRadioChange();
                  },
                  iconSize: 18.h,
                ),
              ),
              prefixIconConstraints: BoxConstraints(maxHeight: 44.h, maxWidth: 50.h),
              suffixIcon: widget.showCloseButton
                  ? Padding(
                      padding: EdgeInsets.only(right: 8.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgCancel,
                        height: 16.h,
                        width: 16.h,
                        onTap: widget.onClose,
                      ),
                    )
                  : null,
              suffixIconConstraints: widget.showCloseButton
                  ? BoxConstraints(maxHeight: 44.h)
                  : null,
              filled: true,
              fillColor: theme.colorScheme.onPrimary,
              isDense: true,
            ),
            style: CustomTextStyles.bodySmallGray80001,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
          ),
        );
      },
    );
  }
}
