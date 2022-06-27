import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwardController = TextEditingController();
    final TextEditingController cpasswardController = TextEditingController();

    void createAccount() async {
      String email = emailController.text.trim();
      String password = passwardController.text.trim();
      String cpassword = cpasswardController.text.trim();

      if (email == "" || password == "" || cpassword == "") {
        Fluttertoast.showToast(msg: "Please fill all the fields!");
      } else if (password != cpassword) {
        Fluttertoast.showToast(msg: "Passward do not match");
      } else {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          if (userCredential.user != null) {
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Fluttertoast.showToast(msg: "The Password Provided is to weak");
          } else if (e.code == 'email-already-in-use') {
            Fluttertoast.showToast(
                msg: "The account already exists for that email.");
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create an account"),
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
                    controller: passwardController,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: cpasswardController,
                    decoration:
                        const InputDecoration(labelText: "Confirm Password"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CupertinoButton(
                    onPressed: () {
                      createAccount();
                    },
                    color: Colors.blue,
                    child: const Text("Create Account"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
