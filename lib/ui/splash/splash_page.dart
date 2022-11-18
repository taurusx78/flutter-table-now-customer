import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/route/routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 170),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  child: const Text('Continue'),
                  onPressed: () {
                    Get.offNamed(Routes.main);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
