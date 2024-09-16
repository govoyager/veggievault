import '../../snackbar.dart';
import '../firebase/firebase_auth.dart';
import '../firebase/firebase_ex.dart';
import 'login.dart';
import '../../loader.dart';
import '../../validator.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'reset_password';
  const ResetPasswordScreen({Key? key}) : super(key: key);
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthenticationService();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
              (route) => false,
        );
        return false;
      },child:Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                            (route) => false,
                      );
                    },
                    child: const Icon(Icons.close),
                  ),
                  const SizedBox(height: 70),
                  const Text(
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter your email address to recover your password.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Email address',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) =>
                        Validator.validateEmail(
                          email: value,
                        ),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                      floatingLabelBehavior:
                      FloatingLabelBehavior.auto,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              LoaderX.show(context);
                              final _status = await _authService.resetPassword(
                                  email: _emailController.text.trim());
                              if (_status == AuthStatus.successful) {
                                LoaderX.hide();
                                Navigator.of(context)
                                    .pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoginScreen(
                                        ),
                                  ),
                                );
                              } else {
                                LoaderX.hide();
                                final error =
                                AuthExceptionHandler.generateErrorMessage(_status);
                                CustomSnackBar.showErrorSnackBar(context,
                                    message: error);
                              }
                            }
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                                color: Colors.white),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(
                                Color(0xff000000)),
                          ),
                        ),
                      ),
                    ],
                  ),],
              ),
            ),
          ),
        )),);
  }
}