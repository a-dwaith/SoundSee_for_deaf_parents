import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soundsee/pages/componets/button.dart';
import 'package:soundsee/pages/componets/squared_tile.dart';
import 'package:soundsee/pages/componets/text_field.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final udidController = TextEditingController();
  final phoneController = TextEditingController();
  final confrimpasswordController = TextEditingController();

  // Sign user
  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      if (passwordController.text == confrimpasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        showerrorMessage('Your request is under observation');

        // add userdata
        addUserData(
          emailController.text.trim(),
          int.parse(phoneController.text.trim()),
          nameController.text.trim(),
          udidController.text.trim(),
        );

        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
      } else {
        showerrorMessage('Password does not match');
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Error message
      showerrorMessage(e.code);
    }
  }

// todo Wrong username error message
  void showerrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future addUserData(
      String email, int mobilenumber, String name, String udid) async {
    await FirebaseFirestore.instance.collection('user_details').add(
      {
        'email': email,
        'mobile_no': mobilenumber,
        'name': name,
        'udid': udid,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Just a Lock Logo

              children: [
                const SizedBox(height: 15),
                // Icon(
                // Icons.lock,
                // size: 100,
                // color: Colors.blue,
                // color: HexColor("#000000"),
                // ),
                Lottie.asset(
                  'lib/assets/images/signup.json',
                  width: 150,
                  height: 150,
                  fit: BoxFit.fill,
                ),

                const SizedBox(height: 15),

                // Welcome note

                const Text(
                  'Let\'s create an account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                MyTextfield(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false,
                ),
                const SizedBox(height: 14),
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 14),

                // Password Text box
                MyTextfield(
                  controller: phoneController,
                  hintText: "Mobile number",
                  obscureText: false,
                ),
                const SizedBox(height: 14),

                MyTextfield(
                  controller: udidController,
                  hintText: "Unique Disability ID",
                  obscureText: false,
                ),
                const SizedBox(height: 14),

                MyTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),
                const SizedBox(height: 14),

                MyTextfield(
                  controller: confrimpasswordController,
                  hintText: "Confrim Password",
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                MyButton(
                  text: 'Sign up',
                  onTap: signUserUp,
                ),

                const SizedBox(height: 25),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Or continue with"),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquaredTile(imagePath: 'lib/assets/images/Google.png')
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the forgot password page
                        Navigator.pushNamed(context, '/loginpage');
                      },
                      child: Text(
                        "Login now!",
                        style: TextStyle(
                          color: HexColor("#0066FF"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
