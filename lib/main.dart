import 'package:chat_app/Screens/calls.dart';
import 'package:chat_app/Screens/chats.dart';
import 'package:chat_app/Screens/people.dart';
import 'package:chat_app/Screens/settings.dart';
import 'package:chat_app/globla.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
  }
  void getMe() async {
    var me = await WhatsApp.Me();
    print('--------------------');
    await WhatsApp.Chats();
    print('--------------------');
    await WhatsApp.People();
    print('--------------------');
    await WhatsApp.Calls();
  }

  var screens = [
    ChatsScreen(), 
    CallsScreen(),
    PeopleScreen(),
    SettingsScreen()
    ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          BottomNavigationBarItem(
            label: "chats",
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
          ),
          BottomNavigationBarItem(
            label: "Calls",
            icon: Icon(CupertinoIcons.phone),
          ),
          BottomNavigationBarItem(
            label: "People",
            icon: Icon(CupertinoIcons.person_alt_circle),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(CupertinoIcons.settings_solid),
          ),
        ]),
        tabBuilder: (BuildContext context, int index){ 
          return Center(
            child: screens[index],
          );
         },
      ));
  }
}
