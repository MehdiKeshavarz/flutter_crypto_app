import 'package:flutter/material.dart';
import 'package:flutter_application_crypto/data/data_source/response_model.dart';
import 'package:flutter_application_crypto/providers/user_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'main_wrapper.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _fromKey = GlobalKey<FormState>();
  bool _isObscure = true;
  late UserProvider userProvider;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Lottie.asset('images/waveloop.json',
              height: height * 0.2, width: double.infinity, fit: BoxFit.fill),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'SignUp',
              style: GoogleFonts.ubuntu(
                fontSize: height * 0.035,
                color: Theme.of(context).unselectedWidgetColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Create Account',
              style: GoogleFonts.ubuntu(
                  fontSize: height * 0.03,
                  color: Theme.of(context).unselectedWidgetColor),
            ),
          ),
          SizedBox(height: height * 0.02),
          Form(
            key: _fromKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    controller: nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some Text';
                      } else if (value.length < 4) {
                        return 'at least enter 4 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      } else if (!value.endsWith('@gmail.com')) {
                        return 'please enter invalid gmail';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          )),
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      } else if (value.length < 7) {
                        return 'at least enter 6 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                    style: GoogleFonts.ubuntu(
                        fontSize: 15, color: Colors.grey, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.02),
                  SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainWrapper()));
                        },
                        child: const Text('Login'),
                      )),
                  SizedBox(height: height * 0.02),
                  Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      switch (userProvider.registerStatus?.status) {
                        case Status.LOADING:
                          return CircularProgressIndicator();
                        case Status.COMPLETED:
                          WidgetsBinding.instance!.addPostFrameCallback(
                              (timeStamp) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MainWrapper())));
                          return signupBtn();
                        case Status.ERROR:
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              signupBtn(),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    userProvider.registerStatus!.message,
                                    style: GoogleFonts.ubuntu(
                                        color: Colors.redAccent, fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          );
                        default:
                          return signupBtn();
                      }
                    },
                  ),

                  //signupBtn(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget signupBtn() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        onPressed: () {
          // Validate returns true if the form is valid, or false otherwise.
          if (_fromKey.currentState!.validate()) {
            userProvider.callRegisterApi(nameController.text,
                emailController.text, passwordController.text);
          }
        },
        child: const Text('Sign Up'),
      ),
    );
  }
}
