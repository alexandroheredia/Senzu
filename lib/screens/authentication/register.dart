import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senzu_app/screens/authentication/services/auth.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function? toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final usernameController = TextEditingController();

  

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    super.dispose();
  }





  final AuthenticationService _auth = AuthenticationService(FirebaseAuth.instance);
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String username = '';
  String email = '';
  String password = '';

  bool _obscureTextPassword = true;


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
                TextFormField(
                    style: textColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: textColor,
                        focusColor: Colors.green,
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF979797))),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF979797))),
                        focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF979797))),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF979797))),
                        errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF979797))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF979797)))
                            ),
                    validator: (val) => val!.isEmpty ? 'Your email goes here UwU' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
              SizedBox(height: 20.0),
              TextFormField(
                style: textColor,
                obscureText: _obscureTextPassword,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: _showPassword,
                    child: FaIcon(
                      _obscureTextPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                    labelText: "Password",
                    labelStyle: textColor,
                    focusColor: Colors.white,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797)))
                        ),
                validator: (val) => val!.length < 6 ? 'Your password must be longer than 6 characters' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    
                    if(result == null) {
                      setState(() {
                        loading = false;
                        error = 'There was an error with the email, either it was badly formatted or there is another account using it already';
                      });
                    }
                  }
            



                },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor, // background
                        foregroundColor: Colors.white, // foreground
                        ),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 75,
                          height: 48,
                        child: Center(
                          child: Builder(
                            builder: (context) {
                              return loading ? loadingWidget : Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Color(0xFFFBFBFB),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500),
                            );  
                            },
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ],
          ),
        ),
    );
  }

  void _showPassword() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}