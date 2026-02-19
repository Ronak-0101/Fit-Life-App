import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CreateSplits extends StatefulWidget {
  const CreateSplits({super.key});

  @override
  State<CreateSplits> createState() => _CreateSplitsState();
}

class _CreateSplitsState extends State<CreateSplits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your own splits'),
      ),
      body: const Center(child: Text('Coming soon...')),
    );
  }
}