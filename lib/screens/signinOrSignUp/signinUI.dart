import 'package:flutter/material.dart';
import 'package:talk_e/components/primary_button.dart';
import 'package:talk_e/screens/chats/chats_screen.dart';
import 'package:talk_e/screens/chats/helperfunction.dart';
import 'package:talk_e/screens/signinOrSignUp/signupUI.dart';
import 'package:talk_e/services/auth.dart';
import 'package:talk_e/services/database.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
 DatabaseMethods databaseMethods =  new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  bool isLoading = false;
  var snapshotUserInfo;

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
            setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByUserEmail(emailTextEditingController.text).then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.docs[0]["name"]);
      });

      authMethods.signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text).then((val){
          if(val != null){

            HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => ChatsScreen()));
          }
          else{
            showDialog(context: context, builder: (context){
              return
                AlertDialog(
                  title: Text("Please Provide Valid Email id and password"),
                  actions: [
                    FlatButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("ok",style: TextStyle(fontSize: 20 , color: Colors.blueAccent),)),
                  ],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  elevation: 24.0,

                );
            });
          }
      });


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                      controller: emailTextEditingController,
                      validator: (val) {
                        return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(val!)
                            ? null
                            : "Please Provide a valid email-Id";
                      },

                      style: TextStyle(color: Colors.white, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.purpleAccent)),

                        prefixIcon: Icon(Icons.email, color: Colors.green,),
                        suffixIcon: IconButton(
                          color: Colors.green,
                          icon: Icon(Icons.close),
                          onPressed: (){

                          },
                        ),

                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: passwordTextEditingController,
                      validator: (val) {
                        return val!.length > 6
                            ? null
                            : "Please provide password of 6+ characters";
                      },
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintStyle: TextStyle(color: Colors.white54),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow)),
                          prefixIcon: Icon(Icons.lock , color: Colors.green,),
                        suffixIcon: IconButton(
                          color: Colors.green,
                          icon: Icon(Icons.close),
                          onPressed: (){
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                child: PrimaryButton(
                  color: Colors.green,
                  text: "Sign In",
                  press: () {
                    signIn();
                  }
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Don't have account ? ",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  TextButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp())),
                      child: Text("Register"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
