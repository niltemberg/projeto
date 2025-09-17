import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/audio_descriptions.dart';

class AudioDescriptionScreen extends StatefulWidget {
  const AudioDescriptionScreen({super.key});

  @override
  State<AudioDescriptionScreen> createState() =>
      _AudioDescriptionScreenState();
}

class _AudioDescriptionScreenState extends State<AudioDescriptionScreen> {
  final TextEditingController _panelController = TextEditingController();
  final FocusNode _panelFocusNode = FocusNode(debugLabel: 'panelInput');
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, AudioDescription> _descriptionIndex =
      buildAudioDescriptionIndex();

  StreamSubscription<PlayerState>? _playerStateSubscription;
  String? _currentPanel;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription =
        _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _panelController.dispose();
    _panelFocusNode.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _announce(BuildContext context, String message) async {
    await SemanticsService.announce(
      message,
      Directionality.of(context),
    );
  }

  Future<void> _playRequestedDescription() async {
    final context = this.context;
    final panelNumber = _panelController.text.trim();

    if (panelNumber.isEmpty) {
      await _announce(context, 'Informe o número do painel para ouvir a descrição.');
      _panelFocusNode.requestFocus();
      return;
    }

    final description = _descriptionIndex[panelNumber];
    if (description == null) {
      await _audioPlayer.stop();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não encontramos audiodescrição para o painel $panelNumber.'),
        ),
      );
      await _announce(context, 'Não encontramos audiodescrição para o painel $panelNumber.');
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.play(UrlSource(description.audioUrl));
    setState(() {
      _currentPanel = panelNumber;
    });

    if (!mounted) return;
    final playingMessage =
        'Reproduzindo audiodescrição do painel ${description.panelNumber}: ${description.title}.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(playingMessage)),
    );
    await _announce(context, playingMessage);
  }

  Future<void> _stopPlayback() async {
    await _audioPlayer.stop();
    setState(() {
      _playerState = PlayerState.stopped;
    });
    if (!mounted) return;
    await _announce(context, 'Reprodução de áudio interrompida.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audiodescrições'),
        actions: [
          if (_playerState == PlayerState.playing)
            IconButton(
              onPressed: _stopPlayback,
              tooltip: 'Parar reprodução',
              icon: const Icon(Icons.stop_circle),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Digite o número do painel e pressione confirmar para ouvir a audiodescrição correspondente.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Semantics(
                container: true,
                child: TextField(
                  controller: _panelController,
                  focusNode: _panelFocusNode,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Número do painel',
                    helperText: 'Utilize apenas números. Exemplo: 1, 2 ou 3.',
                  ),
                  onSubmitted: (_) => _playRequestedDescription(),
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                button: true,
                hint: 'Inicia a audiodescrição do painel informado no campo anterior.',
                child: ElevatedButton.icon(
                  onPressed: _playRequestedDescription,
                  icon: const Icon(Icons.play_circle_fill),
                  label: const Text('Confirmar e ouvir'),
                ),
              ),
              const SizedBox(height: 24),
              if (_currentPanel != null)
                Semantics(
                  liveRegion: true,
                  label: 'Audiodescrição em reprodução',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Painel $_currentPanel em reprodução',
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Expanded(
                child: Semantics(
                  label: 'Lista de painéis com audiodescrição disponível',
                  explicitChildNodes: true,
                  child: ListView.separated(
                    itemCount: kAudioDescriptions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final description = kAudioDescriptions[index];
                      final isCurrent = description.panelNumber == _currentPanel;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          child: Text(description.panelNumber),
                        ),
                        title: Text(description.title),
                        subtitle: Text(description.summary),
                        trailing: Icon(
                          isCurrent ? Icons.volume_up : Icons.play_arrow,
                          color: isCurrent
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        onTap: () {
                          _panelController.text = description.panelNumber;
                          _playRequestedDescription();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
