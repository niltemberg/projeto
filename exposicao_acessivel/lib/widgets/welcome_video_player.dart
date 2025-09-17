import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WelcomeVideoPlayer extends StatefulWidget {
  const WelcomeVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.semanticsLabel,
    required this.semanticsHint,
    this.autoplay = true,
    this.loop = true,
  });

  final String videoUrl;
  final String semanticsLabel;
  final String semanticsHint;
  final bool autoplay;
  final bool loop;

  @override
  State<WelcomeVideoPlayer> createState() => _WelcomeVideoPlayerState();
}

class _WelcomeVideoPlayerState extends State<WelcomeVideoPlayer> {
  late final VideoPlayerController _controller;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..setLooping(widget.loop)
      ..setVolume(1.0)
      ..initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isReady = true;
        });
        if (widget.autoplay) {
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (!_isReady) return;
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final aspectRatio = _isReady ? _controller.value.aspectRatio : 16 / 9;

    return Semantics(
      container: true,
      label: widget.semanticsLabel,
      hint: widget.semanticsHint,
      explicitChildNodes: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: _isReady
                  ? VideoPlayer(_controller)
                  : Container(
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
            ),
            if (_isReady)
              Positioned(
                bottom: 8,
                right: 8,
                child: Semantics(
                  button: true,
                  value: _controller.value.isPlaying
                      ? 'Reproduzindo'
                      : 'Pausado',
                  hint: _controller.value.isPlaying
                      ? 'Toque para pausar o vídeo de boas-vindas.'
                      : 'Toque para retomar o vídeo de boas-vindas.',
                  child: FloatingActionButton.extended(
                    heroTag: 'toggleVideo',
                    onPressed: _togglePlayback,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    label: Text(
                      _controller.value.isPlaying ? 'Pausar' : 'Reproduzir',
                    ),
                    icon: Icon(
                      _controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ),
              ),
            if (_isReady)
              Align(
                alignment: Alignment.bottomCenter,
                child: Semantics(
                  label: 'Barra de progresso do vídeo de boas-vindas',
                  slider: true,
                  child: VideoProgressIndicator(
                    _controller,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    colors: VideoProgressColors(
                      playedColor: theme.colorScheme.primary,
                      bufferedColor: theme.colorScheme.primaryContainer,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
