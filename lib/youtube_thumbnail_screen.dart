import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class YouTubeThumbnailScreen extends StatefulWidget {
  const YouTubeThumbnailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _YouTubeThumbnailScreenState createState() => _YouTubeThumbnailScreenState();
}

class _YouTubeThumbnailScreenState extends State<YouTubeThumbnailScreen> {
  final String apiKey = 'YOUR_API_KEY_HERE';
  final TextEditingController _controller = TextEditingController();
  String? _thumbnailUrl;
  String? _videoUrl;

  Future<void> _getThumbnail(String videoName) async {
    final searchUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$videoName&type=video&key=$apiKey';
    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'].isNotEmpty) {
        final videoId = data['items'][0]['id']['videoId'];
        final thumbnailUrl =
            data['items'][0]['snippet']['thumbnails']['high']['url'];
        setState(() {
          _thumbnailUrl = thumbnailUrl;
          _videoUrl = 'https://www.youtube.com/watch?v=$videoId';
        });
      }
    } else {
      throw Exception('Failed to load video');
    }
  }

  void _launchURL() async {
    if (await launchUrl(Uri.parse(_videoUrl!))) {
      await launchUrl(Uri.parse(_videoUrl!));
    } else {
      throw 'Could not launch $_videoUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Thumbnail App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter YouTube Video Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _getThumbnail(_controller.text),
              child: const Text('Get Thumbnail'),
            ),
            const SizedBox(height: 20),
            _thumbnailUrl != null
                ? GestureDetector(
                    onTap: _launchURL,
                    child: Image.network(_thumbnailUrl!),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
