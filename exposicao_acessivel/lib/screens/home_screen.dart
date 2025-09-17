import 'package:flutter/material.dart';

import '../widgets/welcome_video_player.dart';
import 'audio_description_screen.dart';
import 'curatorial_text_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openCuratorialText(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const CuratorialTextScreen(),
      ),
    );
  }

  void _openAudioDescriptions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AudioDescriptionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exposição Acessível — Vozes do Tempo'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Vozes do Tempo',
                  style: theme.textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bem-vindo! Assista ao vídeo com Libras e áudio de orientação '
                'para saber como aproveitar todos os recursos de acessibilidade.',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              const WelcomeVideoPlayer(
                videoUrl:
                    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                semanticsLabel:
                    'Vídeo introdutório em Libras com narração em áudio.',
                semanticsHint:
                    'Reproduz automaticamente ao abrir a exposição. Toque no botão para pausar ou retomar.',
              ),
              const SizedBox(height: 32),
              Semantics(
                label: 'Acesso rápido às seções da exposição',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _openCuratorialText(context),
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Ler texto curatorial'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _openAudioDescriptions(context),
                      icon: const Icon(Icons.record_voice_over),
                      label: const Text('Ouvir audiodescrições'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Semantics(
                    explicitChildNodes: true,
                    label: 'Informações de acessibilidade',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Recursos inclusivos',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• Vídeo com interpretação em Libras e narração em áudio.\n'
                          '• Descrições em áudio para cada painel da exposição.\n'
                          '• Conteúdo textual com contraste adequado e compatível com leitores de tela.',
                        ),
                      ],
                    ),
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
