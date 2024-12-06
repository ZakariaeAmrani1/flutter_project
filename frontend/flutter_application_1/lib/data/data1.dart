import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactioncategorydata1 = [
  {
    'icon': const FaIcon(
      FontAwesomeIcons.burger,
      color: Colors.white,
      size: 15,
    ),
    'color': Colors.yellow[700],
    'name': 'Food',
  },
  {
    'icon': const FaIcon(
      FontAwesomeIcons.bagShopping,
      color: Colors.white,
      size: 15,
    ),
    'color': Colors.purple,
    'name': 'Shopping',
  },
  {
    'icon': const FaIcon(
      FontAwesomeIcons.heartCircleCheck,
      color: Colors.white,
      size: 15,
    ),
    'color': Colors.green,
    'name': 'Health',
  },
  {
    'icon': const FaIcon(
      FontAwesomeIcons.plane,
      color: Colors.white,
      size: 15,
    ),
    'color': Colors.blue,
    'name': 'Travel',
  },
];
