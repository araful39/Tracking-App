import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_app/controller/auth_controller.dart';
import 'package:tracking_app/screen/sing_up.dart';

class SingInScreen extends StatelessWidget {
  const SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Email'),
            controller: emailController,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Password'),
            controller: passController,
          ),
          Obx(
                () => authController.isLoggedIn.value == true
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: () {
                authController.login(
                    emailController.text, passController.text);
              },
              child: const Text('Login'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const SingUp());
            },
            child: const Text('Signup'),
          ),
        ],
      ),
    );
  }
}