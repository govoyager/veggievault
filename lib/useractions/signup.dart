import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../emailverification.dart';
import 'login.dart';
import '../firebase/firebase_auth.dart';
import '../firebase/firebase_ex.dart';
import '../../validator.dart';
import '../../snackbar.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen(),
          ),
              (route) => false,
        );
        return false;
      },
      child: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  bool _isSecuredPassword = true;

  final _registerFormKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmpasswordTextController = TextEditingController();
  final _otpTextController = TextEditingController();
  final _authService = AuthenticationService();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusconfirmPassword = FocusNode();
  final _focusotpPassword = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusconfirmPassword.unfocus();
        _focusotpPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xff000000)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const LoginScreen() ,
                ),
                    (route) => false,
              );
            },
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Container(
              child:Padding(
                padding: const EdgeInsets.all(24.0),

                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, screenHeight * 0.02, 0, 0),
                        child: const Text(
                          "Signup,",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, screenHeight * 0.005, 0, screenHeight * 0.08),
                        child: const Text(
                          "Cameron Harvest!",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Form(
                        key: _registerFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameTextController,
                              focusNode: _focusName,
                              validator: (value) => Validator.validateName(
                                name: value,
                              ),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Store name",
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                            const SizedBox(height: 12.0),
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
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: _isSecuredPassword,
                              validator: (value) => Validator.validatePassword(
                                password: value,
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                suffixIcon: togglePassword(),
                                labelText: "Password",
                                floatingLabelBehavior: FloatingLabelBehavior.auto,

                              ),
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: _confirmpasswordTextController,
                              focusNode: _focusconfirmPassword,
                              obscureText: _isSecuredPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if(value != _passwordTextController.text) {
                                  return 'Not Match';
                                }
                                return null;
                              },

                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                suffixIcon: togglePassword(),
                                labelText: "Confirm Password",
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),

                            const SizedBox(height: 32.0),
                            _isProcessing
                                ? const CircularProgressIndicator()
                                : Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      String usertype = "users";

                                      if (_registerFormKey.currentState!.validate()) {
                                        final _status = await _authService.createAccount(
                                          email: _emailTextController.text.trim(),
                                          password: _passwordTextController.text,
                                          name: _nameTextController.text,
                                        );
                                        String? uid = FirebaseAuth.instance.currentUser?.uid;
                                        setState(() {
                                          _isProcessing = false;
                                        });
                                        if (_status == AuthStatus.successful) {
                                          final fcmToken = await FirebaseMessaging.instance.getToken();
                                          Map<String, dynamic> data = {
                                            'email': _emailTextController.text,
                                            'name': _nameTextController.text,
                                            'usertype': usertype,
                                          };
                                          await FirebaseFirestore.instance
                                              .collection('user')
                                              .doc(uid)
                                              .set(data);
                                          FirebaseAuth auth = FirebaseAuth.instance;
                                          if(auth.currentUser != null){
                                            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>const EmailVerificationScreen()));
                                          }
                                        }
                                        else {
                                          final error =
                                          AuthExceptionHandler.generateErrorMessage(
                                              _status);
                                          CustomSnackBar.showErrorSnackBar(
                                            context,
                                            message: error,
                                          );
                                        } }else{
                                        setState(() {
                                          _isProcessing = false;
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(const Color(0xff000000)),
                                    ),
                                    child: const Text(
                                      'Sign up',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Center(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const LoginScreen(),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xff000000),
                                      width: 2.0,
                                    ),
                                    minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06), // Adjust the width and height proportions as desired
                                  ),
                                  child: const Text(
                                    "Already have an account? Log In",
                                    style: TextStyle(
                                      color: Color(0xff000000),
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
            ),),),),
    );
  }
  Widget togglePassword(){
    return IconButton(onPressed: (){
      setState(() {
        _isSecuredPassword = !_isSecuredPassword;
      });
    }, icon : _isSecuredPassword? const Icon(Icons.visibility) : const Icon(Icons.visibility_off));
  }

}