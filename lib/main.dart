import 'package:chat_app/Screens/calls.dart';
import 'package:chat_app/Screens/chats.dart';
import 'package:chat_app/Screens/people.dart';
import 'package:chat_app/Screens/settings.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:chat_app/Screens/profile_setup_screen.dart';
import 'package:chat_app/Services/auth_service.dart';
import 'package:chat_app/globla.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configurar emuladores para desarrollo
  if (kDebugMode) {
    try {
      FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8181);
      FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
      print('✅ Firebase Emulators configurados');
    } catch (e) {
      print('⚠️ Emuladores no disponibles: $e');
    }
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    
    return CupertinoApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
      ),
      home: StreamBuilder<User?>(
        stream: authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CupertinoPageScaffold(
              child: Center(child: CupertinoActivityIndicator()),
            );
          }
          
          if (snapshot.hasData && snapshot.data != null) {
            // Usuario autenticado, verificar si tiene perfil completo
            return _AuthWrapper();
          } else {
            // Usuario no autenticado, mostrar login
            return const LoginScreen();
          }
        },
      ),
    );
  }
}

class _AuthWrapper extends StatelessWidget {
  const _AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      return const LoginScreen();
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoPageScaffold(
            child: Center(child: CupertinoActivityIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const LoginScreen();
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>?;
        final hasName = userData != null && 
                       userData['name'] != null && 
                       (userData['name'] as String).isNotEmpty;

        if (hasName) {
          // Usuario tiene perfil completo, mostrar chats
          return const MyHomePage(title: 'Chat App');
        } else {
          // Usuario no tiene perfil, mostrar configuración
          return const ProfileSetupScreen();
        }
      },
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
          return screens[index];
         },
      ));
  }
}
