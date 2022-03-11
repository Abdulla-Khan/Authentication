import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> signIn(String email, pass) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: pass)
            .whenComplete(() => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                ));
        (route) => (false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 40,
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: TextField(
              controller: pass,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                signIn(email.text, pass.text);
              },
              child: Text('Sign Up'))
        ],
      ),
    );
  }
}

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> login(String email, pass) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pass)
            .whenComplete(() => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                ));
        (route) => (false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    Future<UserCredential> signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance
          .signInWithCredential(credential)
          .whenComplete(() => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => Home())));
    }

    Future<UserCredential> signInFacebook() async {
      final LoginResult login = await FacebookAuth.instance.login();
      final OAuthCredential face =
          FacebookAuthProvider.credential(login.accessToken!.token);

      Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));

      return FirebaseAuth.instance.signInWithCredential(face);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 40,
            child: TextField(
              controller: email,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 200,
            height: 40,
            child: TextField(
              controller: pass,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                login(email.text, pass.text);
              },
              child: Text('Login')),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignUp()));
              },
              child: Text('Sign Up')),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: Text('Login Using Google Account')),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                signInFacebook();
              },
              child: Text('Login Using Facebook Account')),
        ],
      ),
    );
  }
}
