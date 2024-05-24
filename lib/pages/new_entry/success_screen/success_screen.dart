import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pillpal/constants.dart';
import 'package:pillpal/pages/home_page.dart';
import 'package:sizer/sizer.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key,});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Medicine added successfully!',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: kPrimaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      )),
            ],
          ),
        ));
  }
}
