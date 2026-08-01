import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senzu_app/services/auth_service.dart';
import 'package:senzu_app/shared/theme.dart';

class Register extends StatefulWidget {

  final Function? toggleView;
  const Register({super.key,  this.toggleView });

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 35.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
                TextFormField(
                    style: textColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        labelText: 'Email',
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
              const SizedBox(height: 20.0),
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
                    labelText: 'Password',
                    labelStyle: textColor,
                    focusColor: Colors.white,
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    disabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797))),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF979797)))
                        ),
                validator: (val) => val!.length < 6 ? 'Your password must be longer than 6 characters' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    setState(() => loading = true);
                    try {
                      await _auth.registerWithEmailAndPassword(email, password);
                      // On success the auth stream switches to Home.
                    } on AuthException catch (e) {
                      setState(() {
                        loading = false;
                        error = e.message;
                      });
                    } on Object {
                      setState(() {
                        loading = false;
                        error = 'There was an error creating your account. Please try again.';
                      });
                    }
                  }
                },
                  style: ElevatedButton.styleFrom(
                        backgroundColor: primaryButtonColor, // background
                        foregroundColor: Colors.white, // foreground
                        ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 75,
                          height: 48,
                        child: Center(
                          child: Builder(
                            builder: (context) {
                              return loading ? loadingWidget : const Text(
                              'Sign Up',
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
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
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
