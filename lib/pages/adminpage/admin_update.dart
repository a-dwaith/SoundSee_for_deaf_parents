// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lottie/lottie.dart';
import 'package:soundsee/pages/componets/button.dart';
import 'package:soundsee/pages/componets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

class UpdateAdminProfile extends StatefulWidget {
  const UpdateAdminProfile({super.key});

  @override
  State<UpdateAdminProfile> createState() => _UpdateAdminProfileState();
}

class _UpdateAdminProfileState extends State<UpdateAdminProfile> {
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
      // print(error);
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

/*
  final docRef = FirebaseFirestore.instance.collection('user_details').doc(userId);

  Future<void> _getUserData() async {
    try {
      final DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        nameController.text = data['name'];
        emailController.text = data['email'];
        phoneController.text = data['mobile_no'];
        // Update other fields as needed
      } else {
        // Handle case where user data not found
      }
    } catch (e) {
      // Handle errors
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }
*/
  // todo To be filled latter
  void updateUserProfile() {}
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
                // const SizedBox(height: 10),
                // MyTextfield(
                // controller: udidController,
                // hintText: "UDID",
                // obscureText: false,
                // ),
                // const SizedBox(height: 10),
                const SizedBox(height: 50),
                MyButton(
                  text: 'Update profile',
                  onTap: updateUserProfile,
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
