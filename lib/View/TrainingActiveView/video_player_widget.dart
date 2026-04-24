import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ExerciseVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String placeholderUrl;
  final bool isPlaying;

  const ExerciseVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.placeholderUrl,
    this.isPlaying = true,
  });

  @override
  State<ExerciseVideoPlayer> createState() => _ExerciseVideoPlayerState();
}

class _ExerciseVideoPlayerState extends State<ExerciseVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(ExerciseVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.dispose();
      _initializePlayer();
    } else if (oldWidget.isPlaying != widget.isPlaying) {
      if (widget.isPlaying) {
        _controller.play();
      } else {
        _controller.pause();
      }
    }
  }

  void _initializePlayer() {
    _isError = false;
    _tryLoadingVideo(widget.videoUrl);
  }

  void _tryLoadingVideo(String url, {int fallbackIndex = 0}) {
    if (fallbackIndex == 0) {
      if (url.startsWith('http')) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        _controller = VideoPlayerController.asset(url);
      }
    } else {
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    }

    _controller.initialize().then((_) {
      if (mounted) {
        _controller.setLooping(true);
        _controller.setVolume(0);
        if (widget.isPlaying) _controller.play();
        setState(() { _isError = false; });
      }
    }).catchError((error) {
      debugPrint("Failed to load: $url (Index: $fallbackIndex)");
      _handleFallback(fallbackIndex);
    });
  }

  void _handleFallback(int currentIndex) {
    if (!mounted) return;

    final String fileName = widget.videoUrl.split('/').last;
    final String baseName = fileName.split('.').first;
    final String gender = widget.placeholderUrl.toLowerCase().contains('woman') ? 'woman' : 'man';
    
    List<String> fallbacks = [
      
      'https://sixpack30.b-cdn.net/videos/${Uri.encodeComponent(baseName)}%20$gender.mp4',
      
      'https://sixpack30.b-cdn.net/videos/${Uri.encodeComponent(baseName)}.mp4',
      
      'https://sixpack30.b-cdn.net/videos/${baseName.replaceAll(' ', '_')}.mp4',
      
      'https://sixpack30.b-cdn.net/videos/${baseName.replaceAll(' ', '-')}.mp4',
    ];

    if (currentIndex < fallbacks.length) {
      _tryLoadingVideo(fallbacks[currentIndex], fallbackIndex: currentIndex + 1);
    } else {
      setState(() { _isError = true; });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return widget.placeholderUrl.startsWith('http')
          ? Image.network(widget.placeholderUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
          : Image.asset(widget.placeholderUrl, fit: BoxFit.cover);
    }

    if (_controller.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      );
    }

    return Stack(
      children: [
        widget.placeholderUrl.startsWith('http')
            ? Image.network(widget.placeholderUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity)
            : Image.asset(widget.placeholderUrl, fit: BoxFit.cover),
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00EF5B),
          ),
        ),
      ],
    );
  }
}
