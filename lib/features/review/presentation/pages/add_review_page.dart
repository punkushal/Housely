import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddReviewPage extends StatefulWidget {
  const AddReviewPage({super.key});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Write a review')));
  }
}
