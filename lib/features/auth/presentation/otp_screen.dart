import 'package:flutter/material.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, this.phone, this.country});

  final String? phone;
  final String? country;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('OTP Screen')),
    );
  }
}
