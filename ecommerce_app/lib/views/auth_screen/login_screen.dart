import 'package:ecommerce_app/consts/colors.dart';
import 'package:ecommerce_app/controllers/auth_controller.dart';
import 'package:ecommerce_app/views/auth_screen/signup_screen.dart';
import 'package:ecommerce_app/widgets/background.dart';
import 'package:ecommerce_app/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts/lists.dart';
import '../../widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(AuthController());
  bool _isPasswordVisible = false;
  final loginFormKey = GlobalKey<FormState>();

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
                  child: Form(
                    key: loginFormKey,
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
                        const Text("Please, login with your information"),
                        const SizedBox(
                          height: 20,
                        ),
                        inputField(
                            controller: controller.emailController,
                            title: "Email Adress",
                            isFilled: true,
                            icon: Icons.email),
                        inputField(
                          controller: controller.passwordController,
                          title: "Password",
                          isPasswordVisible: _isPasswordVisible,
                          onTap: _togglePasswordVisibility,
                          isPassword: true,
                          isFilled: true,
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
                        const SizedBox(
                          height: 20,
                        ),
                        Button(
                            text: 'Login',
                            clicked: () async {
                              await controller.login(context, loginFormKey);
                            }),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account ? ",
                              style: TextStyle(fontSize: 13),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => const SignupScreen(),
                                    transition: Transition.cupertinoDialog);
                              },
                              child: const Text(
                                " Sign up",
                                style: TextStyle(
                                    color: AppColors.mainColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // orDivider(),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: List.generate(
                        //       socialIconList.length,
                        //       (index) => Padding(
                        //             padding: const EdgeInsets.only(
                        //                 top: 10, left: 10, right: 10),
                        //             child: CircleAvatar(
                        //               radius: 15,
                        //               child: Image.asset(socialIconList[index]),
                        //             ),
                        //           )),
                        // )
                      ],
                    ),
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
