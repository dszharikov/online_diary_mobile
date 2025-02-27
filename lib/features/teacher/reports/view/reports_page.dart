import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TeacherReportsPage extends StatelessWidget {
  const TeacherReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReportsPage'), centerTitle: true),
      body: const Center(
        child: Text('ReportsPage is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
