import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:soundsee/pages/componets/button.dart';
import 'package:soundsee/pages/componets/squared_tile.dart';
import 'package:soundsee/pages/componets/text_field.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user
  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      
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
                const SizedBox(height: 20),
                // Icon(
                // Icons.lock,
                // size: 100,
                // color: Colors.blue,
                // color: HexColor("#0066FF"),
                // ),
                Lottie.asset(
                  'lib/assets/images/login.json',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),

                const SizedBox(height: 20),

                // Welcome note

                const Text(
                  'Welcome back',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 50),

                // Username text box

                // Text field
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),

                const SizedBox(height: 15),

                // Password Text box

                MyTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to the forgot password page
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: HexColor("#0066FF")),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                MyButton(
                  text: 'Sign in',
                  onTap: signUserIn,
                ),

                const SizedBox(height: 50),

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
                const SizedBox(height: 50),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquaredTile(imagePath: 'lib/assets/images/Google.png')
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member?"),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the forgot password page
                        Navigator.pushNamed(context, '/signUp');
                      },
                      child: Text(
                        "Register now!",
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
