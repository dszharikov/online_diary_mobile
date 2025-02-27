import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TeacherExamsPage extends StatelessWidget {
  const TeacherExamsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExamsPage'), centerTitle: true),
      body: const Center(
        child: Text('ExamsPage is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
