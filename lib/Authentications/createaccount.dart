import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_log_in/helpers/classes.dart';
import 'package:flutter_log_in/helpers/loadings.dart';
import 'package:http/http.dart' as http;

class Create1 extends StatefulWidget {
  @override
  _Create1State createState() => _Create1State();
}

class _Create1State extends State<Create1> {
  final auth = FirebaseAuth.instance;
  bool obscure1 = true;
  bool obscure2 = true;
  bool isZero = false;
  bool isZero1 = false;
  bool match = true;

  final formKey = GlobalKey<FormState>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  BuildContext? loadingDialogContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Creat Account",
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: this.formKey,
          child: ListView(
            children: <Widget>[
              Column(children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Color.fromARGB(255, 128, 152, 170),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: fullnameController,
                      maxLength: 40,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        prefixIcon: Icon(Icons.person),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey)),
                      ),
                      validator: (value) => value!.trim().isNotEmpty
                          ? null
                          : "Full Name is required",
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color:Color.fromARGB(255, 128, 152, 170),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: usernameController,
                      maxLength: 20,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Username",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color:Colors.grey)),
                      ),
                      validator: (value) => value!.trim().isNotEmpty
                          ? null
                          : "Username is required",
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
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      maxLength: 50,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: "Your Email Address",
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
                      obscureText: obscure1,
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      maxLength: 10,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: match ? null : Colors.red),
                      decoration: InputDecoration(
                          labelText: "Create App Password",
                          prefixIcon: Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color:Colors.grey)),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  obscure1 = !obscure1;
                                });
                              },
                              child: Icon(Icons.visibility))),
                      validator: (value) =>
                          value!.trim().isNotEmpty && value.trim().length > 6
                              ? null
                              : "Password must be at least 7 characters",
                    ),
                  ),
                ),
              ]),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Color.fromARGB(255, 128, 152, 170),
                ),
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextFormField(
                    obscureText: obscure2,
                    keyboardType: TextInputType.text,
                    controller: password2Controller,
                    maxLength: 10,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: match ? null : Colors.red),
                    decoration: InputDecoration(
                        labelText: "Confirm the Password",
                        prefixIcon: Icon(Icons.lock),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Colors.grey)),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscure2 = !obscure2;
                              });
                            },
                            child: Icon(Icons.visibility))),
                    validator: (value) =>
                        value!.trim().isNotEmpty && value.trim().length > 6
                            ? null
                            : "Password must be at least 7 characters",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                       color: Colors.red, 
                        height: 50,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: this._onPressed,
                      child: Container(
                        color:Colors.green,
                        height: 50,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressed() async {
    if (this.formKey.currentState!.validate()) {
      if (password2Controller.text.trim() == passwordController.text.trim()) {
        authenticate();
      } else {
        setState(() {
          match = false;
        });
        showUpDis(this.context, "Passwords Do Not Match!!", "");
      }
    }
  }

  void authenticate() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      _showLoading("Loading...");
      try {
        await auth
            .createUserWithEmailAndPassword(
                email: emailController.text.trim().toLowerCase(),
                password: passwordController.text.trim())
            .then((_) {
          _registerUser();
        }).catchError((err) {
          _closeDialog();
          if (err.message ==
              "The email address is already in use by another account.") {
            showUpDis(this.context, "User Already Exists", err.message);
          } else {
            showUpDis(this.context, "Could Not Create an Account",
                "Please try again later");
          }
        });
      } catch (e) {
        _closeDialog();
        showUpDis(this.context, "Could Not Create an Account",
            "Please try again later");
      }
    } else {
      showUpDis(this.context, 'No Internet Connection',
          'Please connect to internet and try again');
    }
  }

  void _registerUser() async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      User user = auth.currentUser!;

  UserInfom userInfom = UserInfom();

      userInfom.uid = user.uid;
      userInfom.email = user.email;
      userInfom.fullname = fullnameController.text.trim();
      userInfom.username = usernameController.text.trim();
      await firebaseFirestore
          .collection('users')
          .doc(user.email)
          .collection("infom")
          .doc(user.uid)
          .set(userInfom.toMap())
          .then((_) {
        success("success");
      }).catchError((err) {
        success("error");
      });
    } catch (e) {
      success("error");
    }
  }

  success(result) async {
    if ('success' == result) {
      sendEmailMess();
    } else {
      deleteUser(emailController.text.trim().toLowerCase(),
          passwordController.text.trim());
      _closeDialog();
      showUpDis(this.context, "Could Not Create an Account",
          "Please try again later");
    }
  }

  void sendEmailMess() async {
    try {
      await auth.currentUser!.sendEmailVerification().then((_) {
        _logoutUser();
        _closeDialog();
        Navigator.of(context).pop();
        checkEmail(context, "Check Your Email Inbox",
            "Verify your account by clicking on the email that has been sent to ${emailController.text.trim().toLowerCase()}");
      }).catchError((err) {
        _logoutUser();
        _closeDialog();
        Navigator.of(context).pop();
        showUpDis(this.context, "Account Created Successfully",
            "You can login to verify your account");
      });
    } catch (e) {
      _logoutUser();
      _closeDialog();
      Navigator.of(context).pop();
      showUpDis(this.context, "Account Created Successfully",
          "You can login to verify your account");
    }
  }

  void _logoutUser() async {
    if (auth.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }

  void deleteUser(String email, String pass) async {
    User user = auth.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: pass);
    await user.reauthenticateWithCredential(credential).then((value) {
      value.user!.delete();
    }).catchError((onError) => null);
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
