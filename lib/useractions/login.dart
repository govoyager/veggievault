import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:price/dailyprice.dart';
import '../../main.dart';
import 'signup.dart';
import '../firebase/firebase_auth.dart';
import '../firebase/firebase_ex.dart';
import '../../validator.dart';
import '../../home.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../snackbar.dart';
import '../../loader.dart';
import 'reset_password.dart';


class LoginScreen extends StatelessWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const MyStatefulWidget();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  final _authService = AuthenticationService();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isSecuredConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _retrieveLoginDetails();
  }

  Future<void> _retrieveLoginDetails() async {
    String? email = await _storage.read(key: 'email');
    String? password = await _storage.read(key: 'password');
    setState(() {
      _emailTextController.text = email ?? '';
      _passwordTextController.text = password ?? '';
    });
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _authService.logout();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    }

    return firebaseApp;
  }

  Future<bool> _onWillPop() async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Do you want to close the app?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Return 'true' to close the app.
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Return 'false' to stay on the same page.
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (shouldPop ?? false) {
      if (Platform.isAndroid) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
    return false; // Always return 'false' to stay on the same page.
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () {
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4F694C),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xffFCFCFC)),
              onPressed: () async {
                await _authService.logout();
                Navigator.of(context)
                    .pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                    const MyApp(),
                  ),
                );
              },
            ),
            centerTitle: true,
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xff4F694C),
          body: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double paddingWidth = constraints.maxWidth * 0.1;
                    final double screenWidth = constraints.maxWidth;
                    final double screenHeight = constraints.maxHeight;

                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        paddingWidth,
                        screenHeight * 0.07,
                        paddingWidth,
                        0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 50.0, top: 13),
                            child: Text(
                              'Welcome Back!',
                              style: TextStyle(
                                color: Color(0xffFCFCFC),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: Colors.white),
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  ),
                                  style: TextStyle(color: Colors.white), // Input text color
                                ),
                                SizedBox(height: screenHeight * 0.0156),
                                TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: _isSecuredConfirmPassword,
                                  validator: (value) => Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),
                                    labelText: "Password",
                                    labelStyle: TextStyle(color: Colors.white),
                                    suffixIcon: toggleConfirmPassword(),
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  ),
                                  style: const TextStyle(color: Colors.white), // Input text color
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      paddingWidth,
                                      screenHeight * 0.01,
                                      paddingWidth * 0,
                                      0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                              const ResetPasswordScreen(),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 0.0),
                                        ),
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                            color: Color(0xffFCFCFC),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.05),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          _focusEmail.unfocus();
                                          _focusPassword.unfocus();
                                          if (_formKey.currentState!.validate()) {
                                            LoaderX.show(context);
                                            final _status = await _authService.login(
                                              email: _emailTextController.text.trim(),
                                              password: _passwordTextController.text,
                                            );
                                            if (_status == AuthStatus.successful) {
                                              if(FirebaseAuth.instance.currentUser!.emailVerified) {
                                                String usertype = "";
                                                String? uid = FirebaseAuth.instance.currentUser?.uid;
                                                try {
                                                  final DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
                                                  if (doc.exists) {
                                                    usertype = doc['usertype'];
                                                  }
                                                } catch (e) {
                                                  if (kDebugMode) {
                                                    print('Error fetching data from Database: $e');
                                                  }
                                                }
                                                LoaderX.hide();
                                                if (usertype == 'users') {
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) => HomePage(),
                                                    ),
                                                  );
                                                } else if (usertype == 'admin') {
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) => dailyPrice(),
                                                    ),
                                                  );
                                                }
                                                // Save login details
                                                await _storage.write(key: 'email', value: _emailTextController.text.trim());
                                                await _storage.write(key: 'password', value: _passwordTextController.text);
                                              } else {
                                                LoaderX.hide();
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: const Text('Email not verified'),
                                                    content: const Text('Please verify email to login'),
                                                    actions: [
                                                      TextButton(
                                                        child: const Text('Retry'),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: const Text('Resend Email'),
                                                        onPressed: () {
                                                          FirebaseAuth.instance.currentUser?.sendEmailVerification();
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                            } else {
                                              LoaderX.hide();
                                              final error = AuthExceptionHandler.generateErrorMessage(_status);
                                              CustomSnackBar.showErrorSnackBar(
                                                context,
                                                message: error,
                                              );
                                            }
                                          }
                                        },
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(const Color(0xff384E37)),
                                        ),
                                        child: const Text(
                                          'Sign In',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.0391),
                            child: Center(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xff384E37),
                                    width: 2.0,
                                  ),
                                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06), // Adjust the width and height proportions as desired
                                ),
                                child: const Text(
                                  "Don't have an account? SIGN UP",
                                  style: TextStyle(
                                    color: Color(0xffFCFCFC),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget toggleConfirmPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _isSecuredConfirmPassword = !_isSecuredConfirmPassword;
        });
      },
      icon: _isSecuredConfirmPassword
          ? const Icon(Icons.visibility,color: Colors.white,)
          : const Icon(Icons.visibility_off,color: Colors.white,),
    );
  }
}

