import 'package:flutter/material.dart';

Route createSlideFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Animasi slide
      const begin = Offset(1.0, 0.0); // dari kanan
      const end = Offset.zero;
      final slideTween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: Curves.easeInOut),
      );

      // Animasi fade
      final fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(
        CurveTween(curve: Curves.easeInOut),
      );

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 450),
  );
}