import 'package:flutter/material.dart';
class TrackingPage extends StatelessWidget {
  final String orderId;
  const TrackingPage({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تتبع طلبك')),
    body: Center(child: Text('تتبع الطلب: $orderId')),
  );
}
