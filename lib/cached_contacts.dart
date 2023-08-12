import 'package:flutter/material.dart';
import 'package:learning_state_management/providers/contacts_notifier.dart';
import 'package:learning_state_management/providers/person_notifier.dart';
import 'package:provider/provider.dart';

class CachedContacts extends StatelessWidget {
  const CachedContacts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final persons = context.watch<ContactsNotifier>().personsCache;
    print('Cached contact screen built');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cached contacts'),
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];

          final name = person.name;
          return SavedContactItem(
            name: name,
            person: person,
            index: index,
          );
        },
      ),
    );
  }
}

class SavedContactItem extends StatelessWidget {
  const SavedContactItem({
    super.key,
    required this.name,
    required this.person,
    required this.index,
  });

  final String name;
  final PersonModel person;
  final int index;

  @override
  Widget build(BuildContext context) {
    final savedPerson = context.watch<ContactsNotifier>().personsCache[index];

    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(savedPerson.name),
      trailing: IconButton(
        onPressed: () {
          context.read<ContactsNotifier>().toggleContacts(savedPerson);
        },
        icon: const Icon(Icons.cancel),
      ),
    );
  }
}
