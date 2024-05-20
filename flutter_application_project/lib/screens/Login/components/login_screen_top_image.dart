// ignore_for_file: unused_import, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class LoginScreenTopImage extends StatelessWidget {
  const LoginScreenTopImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        Row(
          children: [
            Expanded(
              child: Image.asset(
                width: 250,
                height: 250,
                "assets/images/welcom_screen.png",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
