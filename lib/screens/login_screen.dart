import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signin_signup_tutorial/screens/home_screen.dart';
import 'package:signin_signup_tutorial/screens/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    void login() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email == "" || password == "") {
        Fluttertoast.showToast(msg: "Please fill all the fields!");
      } else {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          if (userCredential.user != null) {
            // ignore: use_build_context_synchronously
            Navigator.popUntil(context, (route) => route.isFirst);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Fluttertoast.showToast(msg: "User Not Found.");
          } else if (e.code == 'wrong-password') {
            Fluttertoast.showToast(msg: "Wrong PassWord");
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Login"),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(labelText: "Email Address"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      login();
                    },
                    color: Colors.blue,
                    child: const Text("Log In"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text("Create an Account"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
