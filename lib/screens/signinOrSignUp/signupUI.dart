import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talk_e/components/primary_button.dart';
import 'package:talk_e/screens/chats/chats_screen.dart';
import 'package:talk_e/screens/chats/helperfunction.dart';
import 'package:talk_e/screens/signinOrSignUp/signinUI.dart';
import 'package:talk_e/screens/signinOrSignUp/verifiyemail.dart';
import 'package:talk_e/services/auth.dart';
import 'package:email_auth/email_auth.dart';
import 'package:talk_e/services/database.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController otpController = new TextEditingController();

  void sendOTP() async {
    EmailAuth.sessionName = "Talk-e";
    var res =
        await EmailAuth.sendOtp(receiverMail: emailTextEditingController.text);
    if (res) {
      print("OTP sent");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => verifyEmail()));
    } else {
      print("problem in sending otp");
    }
  }

  void verifyOTP() {
    var res = EmailAuth.validate(
        receiverMail: emailTextEditingController.text,
        userOTP: otpController.text);
    if (res) {
      print("otp verified");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatsScreen()));
    } else {
      print("invalid otp");
    }
  }

  signMeUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        Map<String, String> userInfoMap = {
          "name": userNameTextEditingController.text,
          "email": emailTextEditingController.text,
          "password": passwordTextEditingController.text,
        };

        HelperFunctions.saveUserEmailSharedPreference(
            emailTextEditingController.text);
        HelperFunctions.saveUserNameSharedPreference(
            userNameTextEditingController.text);

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatsScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height - 50,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/Logo_dark.png"),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val) {
                              return val!.isEmpty || val.length < 2
                                  ? "Please Provide a valid Username"
                                  : null;
                            },
                            controller: userNameTextEditingController,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: "username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          TextFormField(
                            controller: emailTextEditingController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please Provide a valid email-Id";
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: "email",
                              hintStyle: TextStyle(color: Colors.white54),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange)),
                            ),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val!.length > 6
                                  ? null
                                  : "Please provide password of 6+ characters";
                            },
                            controller: passwordTextEditingController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              hintText: "password",
                              hintStyle: TextStyle(color: Colors.white54),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.greenAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: PrimaryButton(
                          color: Colors.green,
                          text: "Sign Up",
                          press: () {
                            signMeUp();
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => verifyEmail()));
                          }),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Already have an account ? ",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ),
                              );
                            },
                            child: Text("Login"))
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
