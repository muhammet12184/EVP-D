import 'package:flutter/material.dart';

class ImecePage extends StatefulWidget {
  const ImecePage({super.key});

  @override
  State<ImecePage> createState() => _ImecePageState();
}

class _ImecePageState extends State<ImecePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İmece Modu'),
      ),
      body: const Center(
        child: Text('İmece - Topluluk Yardımlaşması Sayfası'),
      ),
    );
  }
}
