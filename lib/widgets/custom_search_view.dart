import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension SearchViewStyleHelper on CustomSearchView{
  static OutlineInputBorder get fillGray => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.h),
    borderSide: BorderSide.none,
  );
}

class CustomSearchView extends StatelessWidget{
  CustomSearchView(
    {Key? key,
    this.alignment,
    this.width,
    this.boxDecoration,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged
    }
  ) : super(key: key,);

  final Alignment? alignment;
  final double? width;
  final BoxDecoration? boxDecoration;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return alignment != null
      ? Align(
        alignment: alignment ?? Alignment.center,
        child: searchViewWidget(context)
      ) : searchViewWidget(context);
  }

  Widget searchViewWidget(BuildContext context) => Container(
    width: width ?? double.maxFinite,
    decoration: boxDecoration,
    child: TextFormField(
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      controller: controller,
      focusNode: focusNode,
      onTapOutside: (event) {
        if (focusNode != null) {
          focusNode?.unfocus();
        }
        else{
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      autofocus: autofocus!,
      style: textStyle ?? CustomTextStyles.bodySmallGray800,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      decoration: decoration,
      validator: validator,
      onChanged: (String value){
        onChanged?.call(value);
      },
    ),
  );

  InputDecoration get decoration => InputDecoration(
    hintText: hintText ?? "",
    hintStyle: hintStyle ?? CustomTextStyles.bodySmallGray400,
    prefixIcon: prefix ?? 
      Container(
        margin: EdgeInsets.fromLTRB(14.h, 16.h, 12.h, 16.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgSearch,
          height: 16.h,
          width: 16.h,
        ),
      ),
    prefixIconConstraints: prefixConstraints ??
      BoxConstraints(
        maxHeight: 50.h,
      ),
    suffixIcon: suffix ?? 
      Padding(
        padding: EdgeInsets.only(right: 15.h,),
        child: IconButton(
          onPressed: () => controller!.clear(),
          icon: Icon(
            Icons.clear,
            color: Colors.grey.shade600,
          ),
        ),
      ),
    suffixIconConstraints: suffixConstraints ??
      BoxConstraints(
        maxHeight: 50.h,
      ),
    isDense: true,
    contentPadding: contentPadding ?? 
      EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 16.h,
      ),
    fillColor: fillColor ?? appTheme.gray10001,
    filled: filled,
    border: borderDecoration ?? 
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.h),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1,
        ),
      ),
    enabledBorder: borderDecoration ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.h),
      borderSide: BorderSide(
        color: theme.colorScheme.primary,
        width: 1,
      ),
    ),
    focusedBorder: (borderDecoration ?? OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.h),
    )).copyWith(
      borderSide: BorderSide(
        color: theme.colorScheme.primary,
        width: 1,
      ),
    ),
  );
}