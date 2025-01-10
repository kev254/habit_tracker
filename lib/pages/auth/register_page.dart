import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracker/database/local_database.dart';
import 'package:habit_tracker/database/rest_api/auth_provider.dart';
import 'package:habit_tracker/pages/auth/login_page.dart';
import 'package:habit_tracker/pages/home_page.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/util/app_colors.dart';
import 'package:provider/provider.dart';
import '../../components/app_global_widgets.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _LoginPageState(); // Updated to _LoginPageState
}

class _LoginPageState extends State<RegisterPage> {
  // Updated class name
  DateTime now = DateTime.now();
  String? todayData;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
                text: 'REGISTER',
                color: Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? AppColors.whiteColor
                    : AppColors.secondaryBlack,
              ),
              SizedBox(height: 10),
              SubTitleText(
                text: 'Create account with us and enjoy the habit tracking journey.',
                color: Provider.of<ThemeProvider>(context).themeData == darkMode
                    ? AppColors.whiteColor
                    : AppColors.greyColor,
              ),
              SizedBox(height: 20),
              AppTextField(
                controller: nameCtrl,
                hintText: "Enter your name",
              ),
              AppTextField(
                controller: emailCtrl,
                hintText: "Enter your email",
              ),
              AppPasswordField(
                controller: passwordCtrl,
                hintText: "Enter your password",
              ),
              AppPasswordField(
                controller: confirmPasswordCtrl,
                hintText: "Re-enter your password",
              ),
              SizedBox(height: 15),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  return authProvider.isLoading
                      ? SpinKitChasingDots(
                    color: AppColors.primaryColor,
                  )
                      : Column(
                    children: [
                      SizedBox(
                        width: 330,
                        child: AppButton(
                          label: "Sign up",
                          color: AppColors.secondaryBlack,
                          textColor: AppColors.whiteColor,
                          onPressed: () {
                            if (nameCtrl.text.isNotEmpty &&
                                emailCtrl.text.isNotEmpty &&
                                passwordCtrl.text.isNotEmpty &&
                                confirmPasswordCtrl.text.isNotEmpty) {
                              authProvider.register(
                                context,
                                nameCtrl.text.trim(),
                                emailCtrl.text.trim(),
                                passwordCtrl.text.trim(),
                                null,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("All fields are required."),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      TitleText(text: "OR"),
                      SizedBox(height: 10,),
                      SizedBox(
                        width: 330,
                        child: AppButton(
                          label: "Sign up with Google",
                          color: AppColors.primaryColor,
                          textColor: AppColors.whiteColor,
                          onPressed: () async {
                            if (_googleSignIn != null) {
                              signOutWithGoogle();
                            }
                            var user = await signInWithGoogle();
                            if (user != null) {
                              AuthProvider().register(
                                context,
                                user.displayName!,
                                user.email,
                                user.id!,
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
                    text: "Already have an account?",
                    color: AppColors.greyColor,
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Get.to(LoginPage());
                    },
                    child: SubTitleText(
                      text: "Sign in",
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
      AuthProvider().isLoading = false;
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
