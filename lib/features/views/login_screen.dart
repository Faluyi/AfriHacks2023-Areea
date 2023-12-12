import 'package:areea/features/controllers/auth_controller.dart';
import 'package:areea/features/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),

                const Text(
                  "Welcome to",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  "images/logo.png",
                  width: 300,
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordTextEditingController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (emailTextEditingController.text.trim().isNotEmpty &&
                        passwordTextEditingController.text.trim().isNotEmpty) {
                      setState(() {
                        showProgressBar = true;
                      });

                      await authController.loginUser(
                        emailTextEditingController.text.trim(),
                        passwordTextEditingController.text.trim(),
                      );

                      setState(() {
                        showProgressBar = false;
                      });
                    } else {
                      Get.snackbar("Email or Password is Missing", "Please fill all fields");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade200,
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(SignUpScreen());
                      },
                      child: const Text(
                        "Create Here",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
