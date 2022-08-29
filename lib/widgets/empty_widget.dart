import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String? message;
  const EmptyWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 120,
      child: Center(
        child: Text(message ?? 'No data to display'),
      ),
    );
  }
}
