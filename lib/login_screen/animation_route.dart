import 'package:flutter/material.dart';

Route createRoute(StatefulWidget dest) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => dest,
    transitionDuration: const Duration(milliseconds: 750),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}