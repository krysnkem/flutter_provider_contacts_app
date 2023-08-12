import 'package:flutter/material.dart';
import 'package:learning_state_management/data/dummy_data.dart';
import 'package:learning_state_management/providers/person_notifier.dart';

class ContactsNotifier with ChangeNotifier {
  final List<PersonModel> _personsCache = [];

  // static final List<ContactsNotifier> test = [];
  late DummyData dummyData;

  List<PersonModel> get personsCache => _personsCache;

  void toggleContacts(PersonModel person) {
    if (person.isSaved) {
      _personsCache.remove(person);
    } else {
      _personsCache.add(person);
    }
    person.toggledSavedState();
    notifyListeners();
  }

  void removeAll() {
    for (var person in _personsCache) {
      person.toggledSavedState();
    }
    _personsCache.clear();
    notifyListeners();
  }

  void setUpData(DummyData data) {
    dummyData = data;
  }
}
