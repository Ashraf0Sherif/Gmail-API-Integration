import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all( Radius.circular(4)),
        side: BorderSide(color: Colors.white70),
      ),
      backgroundColor: Colors.black38,
      elevation: 0,
      content: Text(
        message,
        //style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
