import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracker/database/local_database.dart';
import 'package:habit_tracker/database/rest_api/auth_provider.dart';
import 'package:habit_tracker/pages/auth/register_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/util/app_colors.dart';
import 'package:provider/provider.dart';
import '../../components/app_global_widgets.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState(); // Updated to _LoginPageState
}

class _LoginPageState extends State<LoginPage> { // Updated class name
  DateTime now = DateTime.now();
  String? todayData;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  GoogleSignIn _googleSignIn = GoogleSignIn();


  @override
  void initState() {
    // Read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
    todayData = DateFormat('EEEE, d').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: 80,
                width: 80,
              ),
              SizedBox(height: 20),
              TitleText(
                text: 'LOGIN',
                color: Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? AppColors.whiteColor
                    : AppColors.secondaryBlack,
              ),
              SizedBox(height: 10),
              SubTitleText(
                text: 'Session expired. Login to access your account.',
                color: Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? AppColors.whiteColor
                    : AppColors.greyColor,
              ),
              SizedBox(height: 20),
              AppTextField(
                controller: emailCtrl,
                hintText: "Enter your email",
              ),
              SizedBox(height: 15),
              AppPasswordField(
                controller: passwordCtrl,
                hintText: "Enter your password",
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Add "Forgot Password" functionality
                  },
                  child: SubTitleText(
                    text: "Forgot password?",
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return authProvider.isLoading
                      ? SpinKitDualRing(
                    color: AppColors.primaryColor,
                  )
                      : Column(
                    children: [
                      SizedBox(
                        width: 330,
                        child: AppButton(
                          label: "Login",
                          color: AppColors.secondaryBlack,
                          textColor: AppColors.whiteColor,
                          onPressed: () {
                            if (emailCtrl.text.isNotEmpty &&
                                passwordCtrl.text.isNotEmpty) {
                              authProvider.login(
                                context,
                                emailCtrl.text.trim(),
                                passwordCtrl.text.trim(),
                                null,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Email and Password are required."),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      TitleText(text: "OR"),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 330,
                        child: AppButton(
                          label: "Sign in with Google",
                          color: AppColors.primaryColor,
                          textColor: AppColors.whiteColor,
                          onPressed: () async {
                            if (_googleSignIn != null) {
                              signOutWithGoogle();
                            }
                            var user = await signInWithGoogle();
                            if (user != null) {
                              authProvider.login(
                                context,
                                user.email,
                                null,
                                user.id,
                              );
                            }
                          },
                          imagePath: "assets/google_logo.png",
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubTitleText(
                    text: "Don't have an account?",
                    color: AppColors.greyColor,
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Get.to(RegisterPage());
                    },
                    child: SubTitleText(
                      text: "Sign up",
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<GoogleSignInAccount?> signInWithGoogle() async {

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Sign-in failed or canceled");
        return null;
      }
      return googleUser;
    } catch (e) {
      AuthProvider().isLoading=false;
      print("Google Sign-In Error: $e");
    }
  }
  Future<bool> signOutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      return true;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return false;
    }
  }
}

