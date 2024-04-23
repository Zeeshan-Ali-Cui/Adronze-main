import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/firebaseauthservice.dart';
import '../services/firebaseuserdataservice.dart';
import '../Models/model.dart';
import '../views/home.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);
  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  var emailcont = TextEditingController();
  var passwordcont = TextEditingController();
  var namecont = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SignUp"),
        backgroundColor: const Color(0xff29A9AB),
        foregroundColor: Colors.white,
      ),
      body: loading
          ? Center(
        child: SpinKitThreeInOut(
          color: Color(0xff29A9AB),
        ),
      )
          : ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 20),
          Container(
            width: 120,
            margin: EdgeInsets.all(30),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.asset('assets/images/logo.jpg'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: TextField(
              controller: namecont,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.cyan),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: TextField(
              controller: emailcont,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.cyan),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(32.0),
            child: TextField(
              controller: passwordcont,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Colors.cyan),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                filled: true,
                fillColor: Colors.white,
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(30),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: Color(0xff29A9AB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton(
              child: Text(
                'SignUp',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff29A9AB),
              ),
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                firebaseauthservice auth_serv = firebaseauthservice();

                bool check = await auth_serv.signup(emailcont.text, passwordcont.text);
                if (check) {
                  Userdata data = Userdata(
                    FirebaseAuth.instance.currentUser!.uid,
                    namecont.text,
                    emailcont.text,
                    "",
                    "",
                    "",
                  );
                  userdataservice().datastoreonsignup(data);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Sign Up Successfull"),
                    ),
                  );
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Home();
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error Creating user"),
                    ),
                  );
                  setState(() {
                    loading = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
