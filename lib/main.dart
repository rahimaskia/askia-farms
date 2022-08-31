import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'notification_service.dart';
import 'theme/custom_theme.dart';
import 'views/home_page.dart';
import 'views/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: CustomTheme.lightTheme,
        darkTheme: CustomTheme.darkTheme,
        title: 'Askia Farms',
        home: const AuthCheck());
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      debugPrint(receivedNotification.toString());
      final key = receivedNotification.channelKey;
      Navigator.of(context).push<void>(MaterialPageRoute(
          builder: (context) => Homepage(
                index: key != null ? (key == 'feed_channel' ? 3 : 2) : 0,
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return Homepage();
          }
          if (!snapshot.hasData) {
            return const LoginPage();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('That\'s an error: ${snapshot.error}'),
            );
          }
          return const LoginPage();
        },
      ),
    );
  }
}
