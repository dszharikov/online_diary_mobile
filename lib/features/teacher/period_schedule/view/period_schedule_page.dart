import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TeacherPeriodSchedulePage extends StatelessWidget {
  const TeacherPeriodSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PeriodSchedulePage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PeriodSchedulePage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
