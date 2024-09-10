import 'package:acs_auth/screens/signup_email_password_screen.dart';
import 'package:acs_auth/services/firebase_auth_methods.dart';
import 'package:acs_auth/widgets/custom_button.dart';
import 'package:acs_auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

class EmailPasswordLogin extends StatefulWidget {
  static String routeName = '/login-email-password';
  const EmailPasswordLogin({Key? key}) : super(key: key);

  @override
  _EmailPasswordLoginState createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Login",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: emailController,
                    validator: (value) {
                      if (value != null) {
                        final bool isValidEmail =
                            EmailValidator.validate(value);
                        if (!isValidEmail) return 'Invalid Email';
                      }
                      return null;
                    },
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextField(
                    controller: passwordController,
                    hintText: 'Enter your password',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              CustomButton(
                onTap: () {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    loginUser();
                  }
                },
                text: 'Login',
              ),
              const SizedBox(height: 16),
              CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, EmailPasswordSignup.routeName);
                },
                text: 'Email/Password Sign Up',
              ),
              const SizedBox(height: 16),
              CustomButton(
                onTap: () {
                  context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                },
                text: 'Google Sign In',
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
