import 'package:flutter/material.dart';
class RatingPage extends StatelessWidget {
  final String orderId;
  const RatingPage({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('تقييم الخدمة')),
    body: Center(child: Text('تقييم الطلب: $orderId')),
  );
}
