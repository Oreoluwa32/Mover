part of 'personal_information_notifier.dart';

// Represents the state of personal information in the app
// ignore for file, must be immutable
class PersonalInformationState extends Equatable{
  PersonalInformationState({
    this.firstNameController,
    this.lastNameController,
    this.emailController,
    this.phoneNumberController,
    this.facebookLinkController,
    this.instagramLinkController,
    this.linkedinLinkController,
    this.selectedCountry,
    this.personalInformationModelObj
  });

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? emailController;
  TextEditingController? phoneNumberController;
  TextEditingController? facebookLinkController;
  TextEditingController? instagramLinkController;
  TextEditingController? linkedinLinkController;
  PersonalInformationModel? personalInformationModelObj;
  Country? selectedCountry;

  @override
  List<Object?> get props => [
    firstNameController,
    lastNameController,
    emailController,
    phoneNumberController,
    facebookLinkController,
    instagramLinkController,
    linkedinLinkController,
    selectedCountry,
    personalInformationModelObj
  ];
  PersonalInformationState copyWith({
    TextEditingController? firstNameController,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    TextEditingController? phoneNumberController,
    TextEditingController? facebookLinkController,
    TextEditingController? instagramLinkController,
    TextEditingController? linkedinLinkController,
    PersonalInformationModel? personalInformationModelObj,
    Country? selectedCountry,
  }) {
    return PersonalInformationState(
      firstNameController: firstNameController ?? this.firstNameController,
      lastNameController: lastNameController ?? this.lastNameController,
      emailController: emailController ?? this.emailController,
      phoneNumberController: phoneNumberController ?? this.phoneNumberController,
      facebookLinkController: facebookLinkController ?? this.facebookLinkController,
      instagramLinkController: instagramLinkController ?? this.instagramLinkController,
      linkedinLinkController: linkedinLinkController ?? this.linkedinLinkController,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      personalInformationModelObj: personalInformationModelObj ?? this.personalInformationModelObj,
    );
  }
}