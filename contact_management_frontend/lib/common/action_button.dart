import 'package:contact_management_frontend/common/constants.dart';
import 'package:flutter/material.dart';

Widget actionButton(String text){
  return Container(
    height: 50,
    width: double.infinity,
    decoration: BoxDecoration(
      color: kPrimaryColor,
      borderRadius: const BorderRadius.all(
        Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
          color: kPrimaryColor.withOpacity(0.2),
          spreadRadius: 4,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}