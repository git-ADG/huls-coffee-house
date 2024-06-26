import 'dart:math';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:huls_coffee_house/controllers/controllers.dart';
import 'package:huls_coffee_house/models/models.dart';
import 'package:huls_coffee_house/pages/login_ui/utils/authenticator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:huls_coffee_house/config/config.dart';
import 'package:huls_coffee_house/pages/homepage_ui/homepage.dart';
import 'package:huls_coffee_house/pages/login_ui/login_page.dart';
import 'package:huls_coffee_house/pages/login_ui/otp_verification_page.dart';
import 'package:huls_coffee_house/pages/login_ui/widgets/buttons.dart';
import 'package:huls_coffee_house/pages/login_ui/widgets/custom_field.dart';
import 'package:huls_coffee_house/utils/toast_message.dart';
import 'package:huls_coffee_house/widgets/custom_background_image/custom_background_image.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static const String routeName = '/signUpPage';

  static String verifyId = "";
  static String email = "";
  static String password = "";
  static String name = "";
  static String phone = "";
  static String address = "";

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //password showing boolean
  bool isObscurePass = true;
  bool isObscureConfirm = true;

  //form variable
  final _formKey = GlobalKey<FormState>();

  //controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  TextEditingController countryCode = TextEditingController();

  bool isAvailable = false;

  void initState() {
    countryCode.text = "+91";
    super.initState();
  }

  String _generateRandomOtp(int length) {
    final random = Random();
    return List.generate(length, (index) => random.nextInt(10)).join();
  }

  //function to validate form
  void validate() {
    if (_formKey.currentState!.validate()) {
      print("entering validate function");
      showLoadingOverlay(
        context: context,
        asyncTask: () async {
          try {
            List<UserModel> user = await UserController.get(
              email: emailController.text.toString().trim(),
              keepPassword: true,
              forceGet: true,
            ).first;
            if (user.isNotEmpty) {
              isAvailable = true;
              throw Exception("User already exists!");
            }
            final String otp = _generateRandomOtp(6);
            print("email entered is ${emailController.text.toString()}");
            SignupPage.verifyId = otp;
            SignupPage.email = emailController.text.toString();
            SignupPage.password = passController.text.toString();
            SignupPage.name = nameController.text.toString();
            SignupPage.phone = phoneController.text.toString();
            SignupPage.address = addressController.text.toString();

            Authenticator().sendEmailOtp(otp, emailController.text.toString(),
                phoneController.text.toString());

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: Text(
            //         "Code sent to ${SignupPage.email}! Please check spam folder also"),
            //   ),
            // );
            toastMessage(
                "Code sent to ${SignupPage.email}! Please check spam folder also",
                context);
            print("code send $otp");
          } catch (error) {
            // Failed login
            toastMessage(error.toString(), context);
          }
        },
        onCompleted: () {
          if(!isAvailable) {
            Navigator.pushNamed(context, OtpVerificationPage.routeName);
          }
        },
      );
    } else {
      toastMessage("Please enter proper credentials", context);
    }
  }

  //function to show or hide password
  void showPass(String controller) {
    setState(() {
      if (controller == "passController") {
        isObscurePass = !isObscurePass;
      } else if (controller == "confirmController") {
        isObscureConfirm = !isObscureConfirm;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //screen size
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    //constants
    double padding = 16.0;
    double lFontSize = 40.0;
    double gap = 30;
    double sFontSize = 16;
    Color fontColor = const Color.fromRGBO(151, 150, 161, 1);
    Color fontColor2 = const Color.fromRGBO(91, 91, 94, 1);
    Color lineColor = const Color.fromRGBO(179, 179, 179, 0.5);
    double sGap = 10;
    double fieldHeight = height * 0.1;
    double lGap = 70.0;
    double buttonHeight = 60;
    double buttonWidth = 248;
    Color buttonColor = const Color.fromRGBO(254, 114, 76, 1);
    double lineHeight = 2;
    double lineWidth = 100;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: const GoBackButton(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CustomBackground(
                  bodyWidget: SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: lGap * 1.4,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: lFontSize,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'SofiaPro'),
                                ),
                              ),
                              SizedBox(
                                height: gap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  "Full Name",
                                  style: TextStyle(
                                      color: fontColor,
                                      fontSize: sFontSize,
                                      fontFamily: 'SofiaPro'),
                                ),
                              ),
                              SizedBox(
                                height: sGap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: padding, right: padding),
                                child: SizedBox(
                                    height: fieldHeight,
                                    child: CustomField(
                                      controller: nameController,
                                      hintText: "Your Full Name",
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Name cannot be empty";
                                        }
                                        return null;
                                      },
                                    )),
                              ),
                              SizedBox(
                                height: gap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  "E-mail",
                                  style: TextStyle(
                                      fontFamily: 'SofiaPro',
                                      color: fontColor,
                                      fontSize: sFontSize),
                                ),
                              ),
                              SizedBox(
                                height: sGap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: padding, right: padding),
                                child: SizedBox(
                                    height: fieldHeight,
                                    child: CustomField(
                                      controller: emailController,
                                      hintText: "Your email",
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "email cannot be empty";
                                        } else if (!EmailValidator.validate(
                                            value)) {
                                          return "Please enter valid email address";
                                        }
                                        return null;
                                      },
                                    )),
                              ),
                              SizedBox(
                                height: sGap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  "Phone",
                                  style: TextStyle(
                                      fontFamily: 'SofiaPro',
                                      color: fontColor,
                                      fontSize: sFontSize),
                                ),
                              ),
                              SizedBox(
                                height: sGap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: padding, right: padding),
                                child: SizedBox(
                                    height: fieldHeight,
                                    child: CustomField(
                                      controller: phoneController,
                                      hintText: "Your phone number",
                                      textInputType: TextInputType.phone,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "phone number cannot be empty";
                                        }
                                        return null;
                                      },
                                    )),
                              ),
                              SizedBox(
                                height: gap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  "Address",
                                  style: TextStyle(
                                      color: fontColor,
                                      fontSize: sFontSize,
                                      fontFamily: 'SofiaPro'),
                                ),
                              ),
                              SizedBox(
                                height: sGap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: padding, right: padding),
                                child: SizedBox(
                                    height: fieldHeight,
                                    child: CustomField(
                                      controller: addressController,
                                      hintText: "Your college address",
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Address cannot be empty";
                                        }
                                        return null;
                                      },
                                    )),
                              ),
                              SizedBox(
                                height: gap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                      fontFamily: 'SofiaPro',
                                      color: fontColor,
                                      fontSize: sFontSize),
                                ),
                              ),
                              SizedBox(
                                height: sGap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: padding, right: padding),
                                child: SizedBox(
                                  height: fieldHeight,
                                  child: CustomField(
                                    controller: passController,
                                    hintText: "Password",
                                    obscureText: isObscurePass ? true : false,
                                    suffixIcon: IconButton(
                                        onPressed: () =>
                                            showPass("passController"),
                                        icon: isObscurePass
                                            ? const Icon(Icons.visibility)
                                            : const Icon(Icons.visibility_off)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "password cannot be empty";
                                      } else if (value.length < 8) {
                                        return "password must be atleast 8 characters long";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: padding),
                                child: Text(
                                  "Confirm Password",
                                  style: TextStyle(
                                      fontFamily: 'SofiaPro',
                                      color: fontColor,
                                      fontSize: sFontSize),
                                ),
                              ),
                              SizedBox(
                                height: sGap,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: padding, right: padding),
                                child: SizedBox(
                                  height: fieldHeight,
                                  child: CustomField(
                                    controller: confirmController,
                                    hintText: "Confirm Password",
                                    obscureText:
                                        isObscureConfirm ? true : false,
                                    suffixIcon: IconButton(
                                        onPressed: () =>
                                            showPass("confirmController"),
                                        icon: isObscureConfirm
                                            ? const Icon(Icons.visibility)
                                            : const Icon(Icons.visibility_off)),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "confirm password cannot be empty";
                                      } else if (value !=
                                          passController.text.toString()) {
                                        return "Confirm Password must be equal to password";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: lGap,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: buttonHeight,
                            width: buttonWidth,
                            child: CustomButton(
                              onPressed: validate,
                              text: 'GET OTP',
                            ),
                          ),
                          SizedBox(
                            height: sGap,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                    fontFamily: 'SofiaPro',
                                    color: fontColor2,
                                    fontWeight: FontWeight.w500),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ));
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: buttonColor,
                                        fontFamily: 'SofiaPro'),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: sGap,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     Container(
                          //       color: lineColor,
                          //       height: lineHeight,
                          //       width: lineWidth,
                          //     ),
                          //     Text(
                          //       "Sign up with",
                          //       style: TextStyle(
                          //           color: fontColor2,
                          //           fontFamily: 'SofiaPro',
                          //           fontWeight: FontWeight.w500),
                          //     ),
                          //     Container(
                          //       color: lineColor,
                          //       height: lineHeight,
                          //       width: lineWidth,
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: sGap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
