class AudioDescription {
  const AudioDescription({
    required this.panelNumber,
    required this.title,
    required this.summary,
    required this.audioUrl,
  });

  final String panelNumber;
  final String title;
  final String summary;
  final String audioUrl;
}

/// Lista de audiodescrições disponíveis. Os arquivos de áudio são
/// hospedados publicamente apenas para fins de demonstração.
const List<AudioDescription> kAudioDescriptions = [
  AudioDescription(
    panelNumber: '1',
    title: 'Boas-vindas e apresentação da curadoria',
    summary:
        'Introdução ao conceito da exposição e às pessoas responsáveis pela curadoria.',
    audioUrl:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  ),
  AudioDescription(
    panelNumber: '2',
    title: 'Painel 2 — Paisagens sensoriais',
    summary:
        'Descrição das cores predominantes, texturas e elementos táteis do segundo painel.',
    audioUrl:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  ),
  AudioDescription(
    panelNumber: '3',
    title: 'Painel 3 — Trajetórias de artistas',
    summary:
        'Contextualização histórica das obras e biografias das pessoas artistas participantes.',
    audioUrl:
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  ),
];

Map<String, AudioDescription> buildAudioDescriptionIndex() {
  return {for (final item in kAudioDescriptions) item.panelNumber: item};
}
