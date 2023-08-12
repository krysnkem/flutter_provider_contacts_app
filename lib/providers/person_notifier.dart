class PersonModel {
  final String name;
  bool isSaved;

  PersonModel({required this.name, this.isSaved = false});

  void toggledSavedState() {
    isSaved = !isSaved;
  }

  @override
  String toString() {
    return '$name isSaved:$isSaved';
  }
}
