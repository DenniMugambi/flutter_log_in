import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_log_in/Authentications/createaccount.dart';
import 'package:flutter_log_in/Authentications/resetpass.dart';
import 'package:flutter_log_in/helpers/loadings.dart';
import 'package:flutter_log_in/helpers/classes.dart';
import 'package:flutter_log_in/homepage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserInfom userInfom = UserInfom();
  bool obscure = true;
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  BuildContext? loadingDialogContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: this.formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color.fromARGB(255, 128, 152, 170),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Your Email",
                        prefixIcon: Icon(Icons.email),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey)),
                      ),
                      autofillHints: [AutofillHints.email],
                      validator: (email) => email != null &&
                              !EmailValidator.validate(email.trim())
                          ? 'Enter a Valid email'
                          : null,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color.fromARGB(255, 128, 152, 170),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      obscureText: obscure,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: "Your App Password",
                          prefixIcon: Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: Colors.grey)),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscure = !obscure;
                                });
                              },
                              child: Icon(Icons.visibility))),
                      validator: (value) => value!.trim().isNotEmpty
                          ? null
                          : "Password is required",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PassReset()));
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: this._onPressed,
                      child: Container(
                        color: Colors.greenAccent,
                        height: 50,
                        width: 250,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            "Don't have an account?, Create a new one here",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Create1()));
                          },
                          child: Container(
                            height: 50,
                             color:Colors.greenAccent,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onPressed() async {
    if (this.formKey.currentState!.validate()) {
      userLogin();
    }
  }

  void userLogin() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _showLoading("Loading...");
      try {
        await auth
            .signInWithEmailAndPassword(
                email: emailController.text.trim().toLowerCase(),
                password: passwordController.text.trim())
            .then((_) {
          loadUser();
        }).catchError((err) {
          _closeDialog();
          if (err.message ==
              'The supplied auth credential is incorrect, malformed or has expired.') {
            showUpDis(this.context, "Incorrect Email or Password",
                "The password is incorrect and does not match with the email provided");
          } else if (err.message ==
              'There is no user record corresponding to this identifier. The user may have been deleted.') {
            showUpDis(this.context, "No Account With This Email",
                "No user with the Email Address provided, Create a new account if you don't have one");
          } else if (err.message ==
              'We have blocked all requests from this device due to unusual activity. Try again later.') {
            showUpDis(this.context, "Too Many Wrong Attempts", err.message);
          } else if (err.message ==
              'The user account has been disabled by an administrator.') {
            showUpDis(this.context, "Disabled Account", err.message);
          } else {
            showUpDis(this.context, "Could not Login",
                "The issue might be your internet connection. Please try again later.");
          }
        });
      } catch (e) {
        _closeDialog();
        showUpDis(this.context, "Could not Log In", "Please try again");
      }
    } else {
      showUpDis(this.context, "No Internet Connection",
          "Connect to internet and try again");
    }
  }

  loadUser() async {
    User user = auth.currentUser!;
    if (user.emailVerified) {
      try {
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .collection("infom")
            .doc(user.uid)
            .get()
            .then((value) {
          setState(() {
            this.userInfom = UserInfom.fromMap(value.data());
          });
              this._closeDialog();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                HomeP(userInfom: userInfom,)),
        (route) => false);
        }).catchError((err) {
          _logoutUser();
          this._closeDialog();
          showUpDis(this.context, "Could not Log In", "Please try again"
              );
        });
      } catch (e) {
        _logoutUser();
        this._closeDialog();
        showUpDis(this.context, "Could not Log In", "Please try again");
      }
    } else {
      _logoutUser();
      this._closeDialog();
      showVerify("Email Not Verified",
          "Your account's email address is not verified, click on the button below to send a verification request");
    }
  }

  void _logoutUser() async {
    if (auth.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  Future<void> showVerify(String message, String message1) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          content: Text(message1),
          actions: [
            TextButton(
              child: Text('cancel'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.green[900],
                  )),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('send request'.toUpperCase(),
                  style: TextStyle(
                    color:Colors.green[900],
                  )),
              onPressed: () {
                Navigator.pop(context);
                sendVerify();
              },
            ),
          ],
        );
      },
    );
  }

  void sendVerify() async {
    _showLoading("Loading...");
    try {
      await auth.currentUser!.sendEmailVerification().then((_) {
        _closeDialog();
        checkEmail(context, "Check Your Email Inbox",
            "Verify your account by clicking on the email that has been sent to ${emailController.text.trim().toLowerCase()}");
      }).catchError((err) {
        _closeDialog();
        showVerify("Could Not send Verification Email", "Please try again");
      });
    } catch (e) {
      _closeDialog();
      showVerify("Could Not send Verification Email", "Please try again");
    }
  }

  void _closeDialog() {
    if (this.loadingDialogContext != null) {
      Navigator.of(this.loadingDialogContext!).pop();
      this.loadingDialogContext = null;
    }
  }

  Future<void> _showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        this.loadingDialogContext = context;
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.greenAccent,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
