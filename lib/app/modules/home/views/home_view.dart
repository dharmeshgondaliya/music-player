import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: InkWell(
            onTap: () {
              controller.onClickPhoneStorage();
            },
            borderRadius: BorderRadius.circular(15),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 30,
                    top: 25,
                    bottom: 25,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone_android_sharp,
                        size: 50,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Phone Storage",
                        style: TextStyle(fontSize: 22),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
