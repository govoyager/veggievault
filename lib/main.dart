import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:price/useractions/login.dart';
import 'dailyprice.dart';
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
          return MaterialApp(
              home: HomePage());
        }
        else if(firebaseData=='admin'){
          return const MaterialApp(
              home: dailyPrice());
        }
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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay of 2 seconds before navigating to the next page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your next page widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size dynamically
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Use the minimum of screen width and height for sizing to avoid overflow
    final safeDimension = screenWidth < screenHeight ? screenWidth : screenHeight;

    final currentDate = DateTime.now();
    final formattedDay = DateFormat('EEEE').format(currentDate); // Get the day name
    final formattedDate = DateFormat('d MMMM y').format(currentDate); // Get date in "11 August 2022" format

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/leaves.jpg', // Add your image path here
              fit: BoxFit.cover,
            ),
          ),
          // Overlaying semi-transparent white background
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          // Content in the center of the screen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top green text
                Text(
                  'VEGETABLE PRICE',
                  style: TextStyle(
                    fontSize: safeDimension * 0.12, // Use safe dimension for font size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: safeDimension * 0.02), // Dynamic spacing
                // Subtitle text
                Text(
                  'by Cameron Harvest',
                  style: TextStyle(
                    fontSize: safeDimension * 0.05, // Use safe dimension for font size
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: safeDimension * 0.03), // Dynamic spacing
                // Rounded image or circle with leaves inside, wrapped with a circular outline
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Outline color
                      width: 10.0, // Thickness of the outline
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/leaves.jpg', // Add your image path here
                      height: safeDimension * 0.5, // Dynamic height and width based on safe dimension
                      width: safeDimension * 0.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: safeDimension * 0.03), // Dynamic spacing
                // Bottom text with current date and day
                Text(
                  formattedDay, // Display current day
                  style: TextStyle(
                    fontSize: safeDimension * 0.08, // Use safe dimension for font size
                    color: Colors.white,
                    fontFamily: 'Cursive',
                  ),
                ),
                SizedBox(height: safeDimension * 0.01), // Dynamic spacing
                Text(
                  formattedDate, // Display formatted date
                  style: TextStyle(
                    fontSize: safeDimension * 0.045, // Use safe dimension for font size
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

