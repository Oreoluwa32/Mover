import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../core/app_export.dart';

// ignore for file, must be immutable
class CustomPhoneNumber extends StatefulWidget{
  final Country country;
  final Function(Country) onTap;
  final TextEditingController? controller;

  CustomPhoneNumber(
    {Key? key,
    required this.country,
    required this.onTap,
    required this.controller})
    : super(key: key,);

  @override
  _CustomPhoneNumberState createState() => _CustomPhoneNumberState();
}

class _CustomPhoneNumberState extends State<CustomPhoneNumber> {
  late Country selectedCountry;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.country;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.h,),
        border: Border.all(
          color: appTheme.gray400,
          width: 1.h,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {_openCountryPicker(context);},
            child: Container(
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: appTheme.gray400,
                    width: 1.h,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CountryPickerUtils.getDefaultFlagImage(selectedCountry),
                  CustomImageView(
                    imagePath: ImageConstant.imgBlueGrayDownArrow,
                    height: 20.h,
                    width: 25.h,
                    margin: EdgeInsets.only(left: 4.h),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: 260.h,
              margin: EdgeInsets.only(left: 8.h),
              child: TextFormField(
                focusNode: FocusNode(),
                autofocus: true,
                controller: widget.controller,
                style: CustomTextStyles.bodyMediumMulishGray800,
                decoration: InputDecoration(
                  hintText: "+${selectedCountry.phoneCode}",
                  hintStyle: CustomTextStyles.bodyMediumMulishGray800,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      Container(
        margin: EdgeInsets.only(
          left: 10.h,
        ),
        width: 60.h,
        child: Text(
          "+${country.phoneCode}",
          style: TextStyle(fontSize: 14.fSize),
        ),
      ),
      const SizedBox(width: 8.0),
      Flexible(
        child: Text(
          country.name,
          style: TextStyle(fontSize: 14.fSize),
        ),
      )
    ],
  );
  void _openCountryPicker(BuildContext context) => showDialog(
    context: context,
    builder: (context) => CountryPickerDialog(
      searchInputDecoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(fontSize: 14.fSize),
      ),
      isSearchable: true,
      title: Text('Select your country code',
        style: TextStyle(fontSize: 14.fSize)),
      onValuePicked: (Country country) {
        setState(() {
          selectedCountry = country;
        });
        widget.onTap(country);
      },
      itemBuilder: _buildDialogItem,
    ),
  );
}