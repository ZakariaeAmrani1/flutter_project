import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/data1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Iconsgetter {
  static FaIcon getIcon(var id) {
    return transactioncategorydata1[id]['icon'];
  }

  static Color getColor(var id) {
    return transactioncategorydata1[id]['color'];
  }

  static String getName(var id) {
    return transactioncategorydata1[id]['name'];
  }
}
