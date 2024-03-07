
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:YohPal/helpers/loadings.dart';
class PassReset extends StatefulWidget {

  @override
  _PassResetState createState() => _PassResetState();
}

class _PassResetState extends State<PassReset> {
  final auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  BuildContext? loadingDialogContext;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
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
              Container(
                color:Color.fromARGB(255, 128, 152, 170),
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Enter Your Email",
                      prefixIcon:Icon(Icons.email),
                      focusedBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color:Colors.grey)
                ),
                    ),
                    autofillHints:[AutofillHints.email],
                    validator:(email) =>email != null && !EmailValidator.validate(email.trim())?'Enter a Valid email':null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                       color: Colors.red,
                        height: 50,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Back",
                              style: TextStyle(color: Colors.white,
                              fontWeight:FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: this._onPressed,
                      child: Container(
                       color:Colors.grey,
                        height: 50,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Send Request",
                              style: TextStyle(color: Colors.white,
                              fontWeight:FontWeight.w600
                              ),
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

  _onPressed() async{
    if (this.formKey.currentState!.validate()) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        _showLoading("Loading...");
    try{
        await auth.sendPasswordResetEmail(email: emailController.text.trim().toLowerCase()).then((_) {
          _closeDialog();
          Navigator.of(context).pop();
          checkEmail(context,"Check Your Email Inbox","Check the email which has been sent to ${emailController.text.trim().toLowerCase()} to reset your password");
        }).catchError((err){
          _closeDialog();
          if(err.message == "There is no user record corresponding to this identifier. The user may have been deleted."){
            showUpDis(this.context, "No such user with this email",
                "Confirm your email address and try again");
          } else{
            showUpDis(this.context, "Could not reset password",
                "Please try again");
        }
        });
      }catch(e){
       _closeDialog();
       showUpDis(this.context, "Could not reset password",
           "Please try again");
    }
    }else{
        showUpDis(this.context, "No Internet Connection",
            "Please connect to internet and try again");
    }
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
                  fontWeight:FontWeight.bold,
                ),
              )
            ],
          ),
        );
      },
    );
  }

}