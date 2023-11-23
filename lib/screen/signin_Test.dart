import 'package:edtech/widget/big_text.dart';
import 'package:edtech/widget/primary_btn.dart';
import 'package:edtech/screen/homepage.dart';

import 'package:edtech/screen/sign_up.dart';
import 'package:edtech/utils/color.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _errorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackgroundColor3,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  width: 800,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 10, top: 30),
                  decoration: BoxDecoration(
                      color: AppColors.buttonBackgroundColor2,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: BigText(
                          text: "Sign In Page",
                          size: 25,
                          color: Colors.black,
                        )),
                        const SizedBox(
                          height: 50,
                        ),
                        Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a email';
                                    }
                                    if (!_validateEmail(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                      labelText: 'Password'),
                                  //  obscureText: true,

                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    if (!_validatePassword(value)) {
                                      return 'Please enter a valid password';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate() &&
                                _validateEmail(_emailController.text) &&
                                _validatePassword(_passwordController.text)) {
                              _auth
                                  .signInWithEmailAndPassword(
                                email: _emailController.text.toString().trim(),
                                password:
                                    _passwordController.text.toString().trim(),
                              )
                                  .then((value) {
                                Get.snackbar(
                                    "Login ", "Logged in successfully");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage()));
                              }).onError((error, stackTrace) {
                                Get.snackbar("Login Error", error.toString());
                              });
                            }
                          },
                          child: const RoundButton(
                             
                              title: "Sign In",
                              titlecolor: Colors.white),
                        ),
                        if (_errorText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              _errorText,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        CupertinoButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()));
                          },
                          child: const Center(
                            child: Text(
                              "New User?Sign Up",
                              style: TextStyle(
                                  fontSize: 14.0, fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    String emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    RegExp regExp = RegExp(emailPattern);
    //  return regExp.hasMatch(email);
    return true;
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }
}
