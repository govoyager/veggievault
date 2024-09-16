import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:price/useractions/login.dart';
import 'firebase/firebase_auth.dart';
import 'firebase_options.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  final appDocumentDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await Hive.openBox('productsBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  Future<String> fetchDataFromFirebase() async {
    String usertype = "";
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance.collection('user').doc(uid).get();
      if (doc.exists) {
        usertype = doc['usertype'];
        await FirebaseFirestore.instance.collection('user').doc(uid).update({
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data from Database: $e');
      }
    }
    return usertype;
  }
  String firebaseData = '';

  bool isLoading = true;

  void fetchData() async {
    String data = await fetchDataFromFirebase();
    setState(() {
      firebaseData = data;
      isLoading=false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {

    User? user = _auth.currentUser;
    user?.reload();
    if(user != null){
      if(user.emailVerified){
        if(firebaseData=='users'){
          return const MaterialApp(
              home: HomePage());
        }
        // else if(firebaseData=='admin'){
        //   return const MaterialApp(
        //       home: ManagerhomeScreen());
        // }
      }
      else{
        return const MaterialApp(
          home: SplashScreenerror(),
        );
      }
    }
    if(isLoading){
      return const MaterialApp(
        home: SplashScreenloading(),
      );
    }
    else{
      return MaterialApp(
        home: SplashScreen(),
      );
    }
  }
}

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final TextEditingController ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    double multiplier = 0;

    if (kIsWeb) {
      multiplier = 0.3;
    }else{
      multiplier=1;
    }

    return WillPopScope(
        onWillPop: () async {
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
            // Close the app
            if (Platform.isAndroid) {
              // For Android, exit the app
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            } else if (Platform.isIOS) {
              // For iOS, exit the app
              exit(0);
            }
          }

          return false; // Always return 'false' to stay on the same page.
        },
        child: Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff000000), Color(0xff000000)],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Image.asset(
                  'assets/images/Mockup 3D.png',
                  height: screenHeight*0.5,
                ),
                const Spacer(flex: 3),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );// Navigate to LoginScreen using the route
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xff000000),
                          backgroundColor: const Color(0xffffffff),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                            vertical: screenHeight * 0.025,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class SplashScreenloading extends StatelessWidget {
  const SplashScreenloading({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff000000), Color(0xff000000)],
            ),
          ),
          child:const Center(
            child: CircularProgressIndicator(),
          )
      ),
    );
  }
}

class SplashScreenerror extends StatelessWidget {

  const SplashScreenerror({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final authService = AuthenticationService();

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff000000), Color(0xff000000)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Mockup 3D.png',height: screenHeight*0.2,width: screenHeight*0.2,),
                const Text(
                  "Email Not Verified",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    },
                    child: const Text(
                      "Resend Verification Mail",
                      style: TextStyle(fontSize: 16,color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                          const MyApp(),
                        ),
                      );
                    },
                    child: const Text(
                      "Reload",
                      style: TextStyle(fontSize: 16,color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      await authService.logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                          const MyApp(),
                        ),
                      );
                    },
                    child: const Text(
                      "Logout of this account",
                      style: TextStyle(fontSize: 16,color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

