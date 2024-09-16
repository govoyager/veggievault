import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:price/useractions/login.dart';
import '/firebase/firebase_auth.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _authService = AuthenticationService();
  Timer? timer;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Email Successfully Verified")));
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;


    return WillPopScope(
      onWillPop: () async{
        await _authService.logout();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                LoginScreen(),
          ),
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: ()async{
                await _authService.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen(),),
                );
              },
              icon: const Icon(Icons.close,color: Colors.black,),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight*0.1),
                Image.asset('assets/images/mail.png',height: screenHeight*0.3,width: screenHeight*0.3,),
                const Center(
                  child: Text(
                    'A verification link has been sent to ',
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Center(
                    child: Text(
                      '${auth.currentUser?.email}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 57),
                SizedBox(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets
                        .symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff000000),
                        ),
                      ),
                      child: const Text('Resend Mail',style: TextStyle(fontSize: 18),),
                      onPressed: () {
                        try {
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification();
                        } catch (e) {
                          debugPrint('$e');
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets
                        .symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff000000),
                        ),
                      ),
                      child: const Text('Login',style: TextStyle(fontSize: 18),),
                      onPressed: () async {
                        await _authService.logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) =>
                                LoginScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),);
  }
}