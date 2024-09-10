import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:acs_auth/firebase_options.dart';
import 'package:acs_auth/screens/home_screen.dart';
import 'package:acs_auth/screens/login_email_password_screen.dart';
import 'package:acs_auth/screens/re_captcha.dart';
import 'package:acs_auth/screens/signup_email_password_screen.dart';
import 'package:acs_auth/services/firebase_auth_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(
            FirebaseAuth.instance,
          ),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Auth Demo',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
        routes: {
          EmailPasswordSignup.routeName: (_) => const EmailPasswordSignup(),
          EmailPasswordLogin.routeName: (_) => const EmailPasswordLogin(),
          HomeScreen.routeName: (_) => const HomeScreen(),
          ReCaptcha.routeName: (_) => const ReCaptcha(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomeScreen();
    }
    return const EmailPasswordLogin();
  }
}
