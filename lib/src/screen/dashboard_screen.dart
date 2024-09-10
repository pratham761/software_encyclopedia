import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenNewState();
}

class _DashboardScreenNewState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 40,
      width: MediaQuery.of(context).size.width,
      child: const Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
