// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:edtech/controller/controller.dart';
import 'package:edtech/model/bookmark.dart';

import 'package:edtech/screen/sign_up.dart';
import 'package:edtech/services/splash_services.dart';
import 'package:edtech/utils/color.dart';
import 'package:edtech/widget/big_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();

  final bookMarkController = BookMarkController();

  loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmartData = prefs.getString('bookmarkedItem');

    if (bookmartData != null) {
      final decodedData = jsonDecode(bookmartData);
      final bookmark = Bookmark.fromJson(decodedData);

      bookMarkController.bookmark.assignAll(decodedData); // Update t
      print(bookmark);
    }
  }

  @override
  void initState() {
    super.initState();
    splashServices.isLogin(context);
    bookMarkController.bookmark();
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.buttonBackgroundColor3,
        body: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 60),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 50),
                      child: Text("Welcome to EdTech..",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ))),

                  SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    "assets/images/flutter.png",
                    height: 170,
                    alignment: Alignment.center,
                  ),

                  //  RotatingSquare(),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                      "“Being a student is easy. Learning requires actual work.\n—William Crawford“ ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 13,
                        color: Colors.grey,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        " Learn through practical \nexperience",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 18,
                          color: Color.fromARGB(255, 112, 108, 108),
                        ),
                      ),
                      //   Text(" Every Day",
                      //       style: TextStyle(
                      //         fontSize: 18,
                      //         color: Colors.red,
                      //       )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  GestureDetector(
                      onTap: () {
                        Get.to(SignUpScreen());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 90, 236, 114),
                            borderRadius: BorderRadius.circular(10)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: BigText(
                          text: "Get Started",
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
            )));
  }
}
