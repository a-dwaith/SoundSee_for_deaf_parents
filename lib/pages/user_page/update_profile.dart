import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lottie/lottie.dart';
import 'package:soundsee/pages/componets/button.dart';
import 'package:soundsee/pages/componets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final udidController = TextEditingController();
  final phoneController = TextEditingController();
  final confrimpasswordController = TextEditingController();

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
      print(error);
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

  Future<void> updateUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('user_details').doc(user.email);

      // Update data based on entered values
      final updatedData = {
        'name': nameController.text,
        'email': emailController.text,
        'mobile_no': phoneController.text,
      };

      await docRef.update(updatedData);

      // Show a success message (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    } else {
      // Handle case where no user is signed in
      print('No user signed in');
    }
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
                Navigator.pushNamed(context, '/home_page');
              },
            ),
            ListTile(
              leading: const Icon(Icons.update_outlined),
              title: const Text(
                "Update Profile",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/updateuserprofile');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Just a Lock Logo
              children: [
                const Text(
                  'Update profile details',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Lottie.asset(
                  'lib/assets/images/update_profile.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                // Welcome note
                const SizedBox(height: 25),
                MyTextfield(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                // Password Text box
                MyTextfield(
                  controller: phoneController,
                  hintText: "Mobile number",
                  obscureText: false,
                ),
                const SizedBox(height: 50),
                MyButton(
                  text: 'Update profile',
                  onTap: updateUserData,
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
