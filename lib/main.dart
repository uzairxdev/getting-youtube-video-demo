import 'package:flutter/material.dart';
import 'package:getting_youtube_tumbnail/play_video_here.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'YouTube App Demo',
      home: MainScreen(),
    );
  }
}
