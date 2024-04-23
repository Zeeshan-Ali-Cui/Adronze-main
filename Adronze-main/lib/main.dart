import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:adronze/services/firebaseauthservice.dart';
import 'package:adronze/views/home.dart';
import 'package:adronze/views/screen1.dart';
import 'package:adronze/views/Signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 954),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Adronze',
          theme: ThemeData(
            primarySwatch: Colors.cyan,
          ),
          home: child,
          debugShowCheckedModeBanner: false,
        );
      },
      child: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void checkIfUserLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      Timer(
        const Duration(seconds: 8),
            () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home())),
      );
    } else {
      Timer(
        const Duration(seconds: 8),
            () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const screen1())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff29A9AB),
      child: Image.asset('assets/images/dronedeliveryview.gif'),
      height: MediaQuery.of(context).size.height / 2.5,
      width: MediaQuery.of(context).size.width / 2.5,
    );
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  var emailcont = TextEditingController();
  var passwordcont = TextEditingController();
  bool obs = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: const Color(0xff29A9AB),
        foregroundColor: Colors.white,
      ),
      body: loading
          ? Center(
        child: CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff29A9AB)),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  width: 120,
                  margin: EdgeInsets.all(30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.asset('assets/images/logo.jpg'),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                controller: emailcont,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.cyan),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                controller: passwordcont,
                obscureText: obs,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.cyan),
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelText: ' Password ',
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        obs = !obs;
                      });
                    },
                    child: obs ? const Icon(Icons.lock) : const Icon(Icons.lock_open),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: const Color(0xff29A9AB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ElevatedButton(
                child: const Text(
                  'LogIn',
                  style: TextStyle(fontSize: 20.0),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:  Color(0xff29A9AB), // Text color
                ),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  firebaseauthservice auth_serv = firebaseauthservice();

                  bool check = await auth_serv.Signin(emailcont.text, passwordcont.text);
                  if (check) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Sign in Successful"),
                    ));
                    setState(() {
                      loading = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return Home();
                      }),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Email or Password is incorrect"),
                    ));
                  }
                  setState(() {
                    loading = false;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.1, horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                  Text(
                    "Create New Account ?",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.black),
                  ),
                  TextButton(
                    child: Text(
                      "SignUp",
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03, color: Color(0xff29A9AB)),
                    ),
                    onPressed: () {
                      firebaseauthservice auth_serv = firebaseauthservice();
                      auth_serv.signup("email@gmail.com", "password");
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return const signup();
                      }));
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
