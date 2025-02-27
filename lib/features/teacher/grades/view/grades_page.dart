import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TeacherGradesPage extends StatelessWidget {
  const TeacherGradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GradesPage'), centerTitle: true),
      body: const Center(
        child: Text('GradesPage is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
