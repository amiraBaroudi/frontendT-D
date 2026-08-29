import 'package:flutter/material.dart';
class DeliveryConfirmationPage extends StatelessWidget {
  final String orderId;
  const DeliveryConfirmationPage({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تأكيد التسليم')),
    body: Center(child: Text('تأكيد التسليم: $orderId')),
  );
}
