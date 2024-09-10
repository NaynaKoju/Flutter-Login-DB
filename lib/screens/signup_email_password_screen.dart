import 'package:email_validator/email_validator.dart';
import 'package:acs_auth/screens/re_captcha.dart';
import 'package:acs_auth/services/firebase_auth_methods.dart';
import 'package:acs_auth/utils/show_snackbar.dart';
import 'package:acs_auth/widgets/custom_button.dart';
import 'package:acs_auth/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class EmailPasswordSignup extends StatefulWidget {
  static String routeName = '/signup-email-password';
  const EmailPasswordSignup({Key? key}) : super(key: key);

  @override
  _EmailPasswordSignupState createState() => _EmailPasswordSignupState();
}

class _EmailPasswordSignupState extends State<EmailPasswordSignup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPwdController = TextEditingController();
  final GlobalKey<FlutterPwValidatorState> pwdValidatorKey =
      GlobalKey<FlutterPwValidatorState>();

  bool pwdIsValid = false;
  bool emailIsValid = false;
  bool btnClicked = false;
  bool confirmPwdIsValid = false;
  bool? captchaValidated;

  void setPwdIsValid(bool state) => setState(() {
        pwdIsValid = state;
        if (btnClicked) formKey.currentState!.validate();
      });

  void setEmailIsValid(String email) => setState(() {
        bool isEmailValid = EmailValidator.validate(email);
        emailIsValid = isEmailValid;
        if (btnClicked) formKey.currentState!.validate();
      });

  void setBtnClickedToTrue() => setState(() {
        btnClicked = true;
      });

  void setConfirmPwdIsValid(bool state) => setState(() {
        confirmPwdIsValid = state;
        if (btnClicked) formKey.currentState!.validate();
      });

  void signUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        );
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setEmailIsValid(emailController.text);
    });
    passwordController.addListener(() {
      setConfirmPwdIsValid(
          passwordController.text == confirmPwdController.text);
    });
    confirmPwdController.addListener(() {
      setConfirmPwdIsValid(
          passwordController.text == confirmPwdController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 36),
              const Text(
                "Sign Up",
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
                            if (!emailIsValid) return 'Invalid Email';
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
                        validator: (value) {
                          if (!pwdIsValid) {
                            return "Password requirement not passed";
                          }
                          return null;
                        },
                        hintText: 'Enter your password',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: FlutterPwValidator(
                        key: pwdValidatorKey,
                        controller: passwordController,
                        minLength: 8,
                        uppercaseCharCount: 2,
                        numericCharCount: 2,
                        specialCharCount: 1,
                        normalCharCount: 3,
                        width: MediaQuery.of(context).size.width,
                        height: 130,
                        onSuccess: () {
                          setPwdIsValid(true);
                        },
                        onFail: () {
                          setPwdIsValid(false);
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomTextField(
                        controller: confirmPwdController,
                        validator: (value) {
                          if (!confirmPwdIsValid) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                        hintText: 'Confirm your password',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: CustomButton(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    setBtnClickedToTrue();
                    if (formKey.currentState != null &&
                        formKey.currentState!.validate()) {
                      if (captchaValidated == true) {
                        signUpUser();
                      } else {
                        bool validated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext newCtx) =>
                                  const ReCaptcha(),
                              fullscreenDialog: true,
                            ));
                        if (validated == true) {
                          showSnackBar(context, "User Validated");
                        } else if (validated == false) {
                          showSnackBar(context, "Could Not Validate User");
                        }
                        setState(() {
                          captchaValidated = validated;
                        });
                      }
                    }
                  },
                  text: captchaValidated == true ? "Sign Up" : "Verify",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPwdController.dispose();
  }
}
