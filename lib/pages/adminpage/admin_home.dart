import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:hexcolor/hexcolor.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Future<void> _sendEmail() async {
    final Email email = Email(
        body: '',
        subject: '[SoundSee Feedback]',
        recipients: ['dwaithmk@gmail.com'],
        cc: [],
        bcc: [],
        attachmentPaths: [],
        isHTML: false);
    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sorry, an error occurred.'),
        ),
      );
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#0066FF"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  "SoundSee",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/admin_home');
              },
            ),
            ListTile(
              leading: const Icon(Icons.update_outlined),
              title: const Text(
                "Update Profile",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/admin_update');
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_outlined),
              title: const Text(
                "Feedback",
                style: TextStyle(fontSize: 20),
              ),
              onTap: _sendEmail,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
              onTap: signOut,
            )
          ],
        ),
      ),
      body: const Center(
        child: Text("Welcome Admin"
        ),
      ),
    );
  }
}
