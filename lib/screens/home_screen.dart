import 'package:firebase_auth/firebase_auth.dart';
import 'package:acs_auth/services/firebase_auth_methods.dart';
import 'package:acs_auth/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/home-screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<User?>(
        builder: (context, user, child) {
          if (user == null) return const Text("No User");
          user.reload();
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("User's email: ${user.email!}"),
                Text("User's uuid: ${user.uid}"),
                const SizedBox(height: 16),
                if (!user.emailVerified)
                  Column(
                    children: [
                      const Text("Your email is not verified."),
                      CustomButton(
                        onTap: () {
                          context
                              .read<FirebaseAuthMethods>()
                              .sendEmailVerification(context);
                        },
                        text: 'Verify Email',
                      ),
                    ],
                  ),
                if (user.emailVerified) const Text("Your email is verified."),
                const SizedBox(height: 16),
                CustomButton(
                  onTap: () {
                    context.read<FirebaseAuthMethods>().signOut(context);
                  },
                  text: 'Sign Out',
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onTap: () {
                    context.read<FirebaseAuthMethods>().removeAccount(context);
                  },
                  text: 'Remove Account',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
