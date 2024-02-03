import 'package:flutter/material.dart';
import 'main_menu_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Database object is ready to be created and used

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // So this widget serves as basically the root of our application.
  // and that ends up being super convinient as we can do things that should
  // remain relatively consistent over the course of the application as a whole
  // (theme data, for example). The other nice thing is that if we make our component
  // parts of the application into their own classes/widgets, then we can simply call them from here
  //
  // This will allow us to work on things outside of the order that we might otherwise have to
  // For example, I don't feel like doing login stuff right now and would rather
  // focus on the menu that a user would see after they logged in. So I'm going to
  // create a main menu widget in a separate file (remember to import) and then call
  // that in the home parameter of our MaterialApp object (though it might still say
  // test widge at the time that you're reading this... in which case all I've done
  // so far is set up consistent theming for the application)
  @override
  Widget build(BuildContext context) {

    FirebaseFirestore db = FirebaseFirestore.instance;

// Create a new user with a first and last name
    final user = <String, dynamic>{
      "first": "Ada",
      "last": "Lovelace",
      "born": 1815
    };

// Add a new document with a generated ID
    db.collection("users").add(user).then((DocumentReference doc) =>
        print('DocumentSnapshot added with ID: ${doc.id}'));


    return MaterialApp(
      title: 'Innovaluation TST App',
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
          surface: const Color(0xff8f8f8f),
        ),
        scaffoldBackgroundColor: const Color(0xffbabab8),
      ),
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
              surface: const Color.fromARGB(255, 42, 51, 59)
          ),
          scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60)
      ),
      home: MainMenuView(),
    );
  }
}

class _TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Innovaluation TST"),
      ),
      body: const Center(
        child: Text("This is a test widget"),
      ),
    );
  }

}
