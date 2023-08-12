import 'package:flutter/material.dart';
import 'package:learning_state_management/cached_contacts.dart';
import 'package:learning_state_management/data/dummy_data.dart';
import 'package:learning_state_management/providers/contacts_notifier.dart';
import 'package:learning_state_management/providers/settings_screen_notifier.dart';
import 'package:learning_state_management/settings_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsScreenNotifier()),
          Provider(
            create: (context) => DummyData(),
          ),
          ChangeNotifierProxyProvider<DummyData, ContactsNotifier>(
            create: (context) => ContactsNotifier(),
            update: (BuildContext context, DummyData data,
                ContactsNotifier? contacts) {
              if (contacts == null) throw ArgumentError.notNull('contacts');
              contacts.setUpData(data);
              return contacts;
            },
          ),
        ],
        builder: (context, provider) {
          return Consumer<SettingsScreenNotifier>(
            builder: (context, notifier, child) {
              return MaterialApp(
                theme: ThemeData(primarySwatch: Colors.blue),
                debugShowCheckedModeBanner: false,
                darkTheme: ThemeData.dark(),
                themeMode: notifier.isDarkModeEnabled
                    ? ThemeMode.dark
                    : ThemeMode.light,
                home: const MyHomePage(title: 'State Example'),
              );
            },
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    print('Home page build');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Builder(
            builder: (context) {
              final personsIsEmpty = context.select<ContactsNotifier, bool>(
                (contactsNotifier) => contactsNotifier.personsCache.isEmpty,
              );
              return IconButton(
                onPressed: personsIsEmpty
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CachedContacts(),
                          ),
                        );
                      },
                icon: Icon(
                  Icons.contacts_rounded,
                  color: personsIsEmpty ? Colors.grey : Colors.white,
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: context.read<ContactsNotifier>().dummyData.persons.length,
        itemBuilder: (context, index) => Builder(
          builder: (_) {
            return PersonListItem(
              index: index,
            );
          },
        ),
      ),
    );
  }

  // void toggleNamesCache(String name) {
  //   if (namesCache.contains(name)) {
  //     namesCache.remove(name);
  //   } else {
  //     namesCache.add(name);
  //   }
  //   setState(() {});
  // }
}

class PersonListItem extends StatelessWidget {
  const PersonListItem({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final person = context.read<ContactsNotifier>().dummyData.persons[index];
    print('build item containing ${person.name}');

    return Container(
      color: index % 2 == 0
          ? const Color(0x0f000000)
          : Theme.of(context).scaffoldBackgroundColor.withOpacity(1),
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(person.name),
        trailing: Builder(
          builder: (context) {
            print(person);
            print('built add button with name ${person.name}');
            final personIsSaved = context.select<ContactsNotifier, bool>(
              (contactNotifier) {
                return contactNotifier.personsCache.contains(person) &&
                    person.isSaved;
              },
            );
            // final person = context.select<ContactsNotifier, PersonNotifier>(
            //   (contactsNotifier) => contactsNotifier.pedrsonsCache[index],
            // );
            if (personIsSaved) {
              return const Icon(Icons.check);
            } else {
              return Text(
                'ADD',
                style: Theme.of(context).textTheme.bodySmall,
              );
            }
          },
        ),
        onTap: () {
          context.read<ContactsNotifier>().toggleContacts(person);
        },
      ),
    );
  }
}
