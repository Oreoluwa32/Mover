// Selction pop up model is used to set up data into dropdowns
// ignore for file, must be immutable
class SelectionPopupModel {
  SelectionPopupModel(
    {
      this.id,
      required this.title,
      this.value,
      this.isSelected = false
    }
  );

  int? id;
  
  String title;

  dynamic value;
  
  bool isSelected;
}