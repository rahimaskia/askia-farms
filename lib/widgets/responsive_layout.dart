import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  const ResponsiveLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: child));
  }
}
