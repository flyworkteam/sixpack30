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
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          _controller.setLooping(true);
          _controller.setVolume(0); 
          if (widget.isPlaying) {
            _controller.play();
          }
          setState(() {});
        }
      }).catchError((error) {
        debugPrint("Video error: $error");
        if (mounted) {
          setState(() {
            _isError = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Image.network(
        widget.placeholderUrl,
        fit: BoxFit.cover,
      );
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
        Image.network(
          widget.placeholderUrl,
          fit: BoxFit.cover,
        ),
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00EF5B),
          ),
        ),
      ],
    );
  }
}
