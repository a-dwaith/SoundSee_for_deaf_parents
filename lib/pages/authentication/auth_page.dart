import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soundsee/pages/user_page/homepage.dart';
import 'package:soundsee/pages/authentication/login_page.dart';
import 'package:soundsee/pages/adminpage/admin_home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // User logged in
          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user != null) {
              // Check if the user email is for admin
              if (user.email == 'admin@soundsee.com') {
                // Navigate to admin home page
                return const AdminHomePage();
              } else {
                // Navigate to user home page
                return const HomePage();
              }
            }
            // If for some reason user is null, log out
            FirebaseAuth.instance.signOut();
            return const LogInPage();
          }
          // User not logged in
          else {
            return const LogInPage();
          }
        },
      ),
    );
  }
}
