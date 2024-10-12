import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tracking_app/controller/auth_controller.dart';

class SingUp extends StatelessWidget {
  const SingUp({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
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
                () => authController.isLoggedIn.isTrue
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: () {
                authController.signUp(
                    emailController.text, passController.text);
              },
              child: const Text('Registration'),
            ),
          )
        ],
      ),
    );
  }
}