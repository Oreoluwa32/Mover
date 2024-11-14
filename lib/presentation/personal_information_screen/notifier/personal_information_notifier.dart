import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/personal_information_model.dart';
part 'personal_information_state.dart';

final personalInformationNotifier = StateNotifierProvider.autoDispose<PersonalInformationNotifier, PersonalInformationState>(
  (ref) => PersonalInformationNotifier(PersonalInformationState(
    firstNameController: TextEditingController(),
    lastNameController: TextEditingController(),
    emailController: TextEditingController(),
    phoneNumberController: TextEditingController(),
    facebookLinkController: TextEditingController(),
    instagramLinkController: TextEditingController(),
    linkedinLinkController: TextEditingController(),
    selectedCountry: CountryPickerUtils.getCountryByPhoneCode('1'),
  )),
);

// A notifier that manages the state of a create account according to the event dispatched to it
class PersonalInformationNotifier extends StateNotifier<PersonalInformationState> {
  PersonalInformationNotifier(PersonalInformationState state) : super(state);
}