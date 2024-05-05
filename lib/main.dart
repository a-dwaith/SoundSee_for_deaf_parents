import 'package:flutter/material.dart';
import 'package:soundsee/pages/adminpage/admin_home.dart';
import 'package:soundsee/pages/adminpage/admin_update.dart';
import 'package:soundsee/pages/authentication/forgot_password.dart';
import 'package:soundsee/pages/user_page/homepage.dart';
import 'package:soundsee/pages/authentication/login_page.dart';
import 'package:soundsee/pages/authentication/auth_page.dart';
import 'package:soundsee/pages/authentication/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:soundsee/pages/user_page/notification_history.dart';
import 'package:soundsee/pages/user_page/update_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alerts',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple)
    ],
    debug: true,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ksebigkerxwbktkugqdl.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzZWJpZ2tlcnh3Ymt0a3VncWRsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQyMTI3MTksImV4cCI6MjAyOTc4ODcxOX0.nfxSiHwATmFPHt0wqKrim2dLfcSxYh_jRu6Wcf8gefE',
  );

  // Get a reference to your Supabase client
  // final supabase = Supabase.instance.client;

  // Remove native splash screen
  FlutterNativeSplash.remove();
  runApp(const SoundSee());
}

class SoundSee extends StatelessWidget {
  const SoundSee({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Ubuntu'),
      // home: const AuthPage(),

      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const AuthPage(),
        '/forgot_password': (_) => const ForgotPasswordScreen(),
        '/signUp': (_) => const Signuppage(),
        '/home_page': (_) => const HomePage(),
        '/loginpage': (_) => const LogInPage(),
        '/updateuserprofile': (_) => const UpdateProfile(),
        '/admin_home': (_) => const AdminHomePage(),
        '/admin_update': (_) => const UpdateAdminProfile(),
        '/notification_page': (_) => const NotificationHistoryPage(),
      },
    );
  }
}
