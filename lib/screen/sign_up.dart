// ignore_for_file: prefer_const_constructors

import 'package:edtech/widget/big_text.dart';
import 'package:edtech/widget/primary_btn.dart';
import 'package:edtech/screen/signin_Test.dart';
import 'package:edtech/utils/color.dart';
import 'package:edtech/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpTest();
}

class _SignUpTest extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final pNumber = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool ishidden = true;
  void dispos() {
    super.dispose();
    email.dispose();
    password.dispose();
    name.dispose();
    pNumber.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonBackgroundColor3,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                width: 800,
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 30),
                decoration: BoxDecoration(
                    color: AppColors.buttonBackgroundColor2,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: BigText(
                        text: "Sign Up Page",
                        size: 25,
                        color: Colors.black,
                      )),
                      const SizedBox(
                        height: 15,
                      ),
                      Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: name,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    hintText: "Name "),
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (value.length < 5) {
                                    return 'Please enter a valid name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a phone number';
                                  }
                                  if (!_validatePhoneNumber(value)) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                                controller: pNumber,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    hintText: "Phone Number "),
                              ),
                              TextFormField(
                                controller: email,
                                decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email_outlined),
                                    hintText: "Email "),
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
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  if (!_validatePassword(value)) {
                                    return 'Please enter a valid password';
                                  }
                                  return null;
                                },
                                controller: password,
                                obscureText: ishidden,
                                decoration: InputDecoration(
                                    suffixIcon: CupertinoButton(
                                        onPressed: () {
                                          setState(() {
                                            ishidden = !ishidden;
                                          });
                                        },
                                        child: ishidden
                                            ? const Icon(Icons.visibility_off)
                                            : const Icon(
                                                Icons.visibility,
                                              )),
                                    hintText: 'Password',
                                    prefixIcon: const Icon(
                                      Icons.password_outlined,
                                      size: 25,
                                    )),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate() &&
                                _validateEmail(email.text.toString()) &&
                                _validatePhoneNumber(pNumber.text) &&
                                _validatePassword(password.text)) {
                              _auth
                                  .createUserWithEmailAndPassword(
                                email: email.text.toString().trim(),
                                password: password.text.toString().trim(),
                              )
                                  .then((value) {
                                Get.snackbar(
                                    "Sign Up ", "Sign Up  SUccesfully");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignInScreen()));
                              }).onError((error, stackTrace) {
                                Get.snackbar(
                                    "Sign Up Error ", "error.toString()");
                              });
                            } else {
                              Get.snackbar("Sign Up ", "Clicked");
                            }
                          },
                          child: Center(
                            child: RoundButton(
                                title: "Sign Up", titlecolor: Colors.white),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()));
                        },
                        child: const Center(
                          child: Text(
                            "Already Have an Account?Login",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validateEmail(String email) {
    // Regular expression for a simple email validation
    if (email.contains('@')) {
      return true;
    } else
      return false;
  }

  bool _validatePassword(String password) {
    return password.length >= 6;
  }

  bool _validatePhoneNumber(String number) {
    return number.length == 11;
  }
}
