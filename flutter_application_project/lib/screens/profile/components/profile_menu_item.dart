// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../size_config.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final void Function() press;

  @override
  Widget build(BuildContext context) {
    double defaultSize = SizeConfig.defaultSize;
    return InkWell(
      onTap: press,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultSize * 2, vertical: defaultSize * 3),
        child: SafeArea(
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                size: defaultSize * 3,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              SizedBox(width: defaultSize * 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: defaultSize * 1.6,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const Spacer(),
              Icon(
                SolarIconsBold.altArrowRight,
                size: defaultSize * 2.5,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
