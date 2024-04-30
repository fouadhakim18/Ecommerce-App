import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../const/colors.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/background.dart';
import '../../widgets/button.dart';
import '../../widgets/input_fields.dart';
import '../../widgets/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isChecked = false;

  final controller = Get.put(AuthController());

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                ),
                body: bgWidget(
                    child: SizedBox(
                  width: double.maxFinite,
                  child: Card(
                    color: AppColors.lightGrey4,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 32.0, left: 25, right: 25, bottom: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome ,",
                            style: TextStyle(
                                color: AppColors.mainColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text("Please, signup with your information"),
                          const SizedBox(
                            height: 20,
                          ),
                          inputField(
                              controller: nameController,
                              isFilled: true,
                              title: "Name",
                              icon: Icons.person),
                          inputField(
                              controller: emailController,
                              title: "Email",
                              isFilled: true,
                              icon: Icons.email),
                          inputField(
                            isFilled: true,
                            controller: passwordController,
                            title: "Password",
                            isPasswordVisible: _isPasswordVisible,
                            onTap: _togglePasswordVisibility,
                            isPassword: true,
                            icon: _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const InkWell(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Forgot password ? ",
                                style: TextStyle(
                                    fontSize: 13, color: AppColors.mainColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                activeColor: AppColors.mainColor,
                                checkColor: Colors.white,
                                fillColor: const MaterialStatePropertyAll(
                                    AppColors.mainColor),
                                value: _isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: RichText(
                                    text: const TextSpan(children: [
                                  TextSpan(
                                      text: "I agree to the ",
                                      style: TextStyle(color: Colors.grey)),
                                  TextSpan(
                                      text: "Terms and Conditions",
                                      style: TextStyle(
                                        color: AppColors.mainColor,
                                      )),
                                  TextSpan(
                                      text: " & ",
                                      style: TextStyle(color: Colors.grey)),
                                  TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                        color: AppColors.mainColor,
                                      )),
                                ])),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Button(
                            text: 'Sign Up',
                            clicked: () async {
                              if (_isChecked) {
                                try {
                                  await controller.signUp(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(), context: context);
                                } catch (e) {
                                  Utils.showToast(e.toString());
                                }
                              }
                            },
                            color:
                                _isChecked ? AppColors.mainColor : Colors.grey,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account ? ",
                                style: TextStyle(fontSize: 13),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))),
          ));
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const [
          Expanded(
              child: Divider(
            thickness: 1,
            color: Colors.grey,
          )),
          SizedBox(
            width: 10,
          ),
          Text("Or"),
          SizedBox(
            width: 10,
          ),
          Expanded(
              child: Divider(
            thickness: 1,
            color: Colors.grey,
          ))
        ],
      ),
    );
  }
}
