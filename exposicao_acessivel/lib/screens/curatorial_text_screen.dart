import 'package:flutter/material.dart';

class CuratorialTextScreen extends StatelessWidget {
  const CuratorialTextScreen({super.key});

  static const List<String> _paragraphs = [
    'A exposição "Vozes do Tempo" apresenta narrativas visuais e sonoras '
        'sobre memórias coletivas. As obras reunidas exploram a relação '
        'entre passado e futuro a partir de experiências sensoriais.',
    'Cada sala conta com peças táteis, descrições sonoras e recursos visuais '
        'pensados para acolher diferentes corpos e modos de percepção. '
        'O público é convidado a caminhar em seu próprio ritmo, descobrindo '
        'novas camadas de significado em cada parada.',
    'A curadoria reforça o compromisso com a acessibilidade cultural. '
        'Além do conteúdo multimídia, a equipe educativa preparou oficinas '
        'e visitas mediadas que ampliam as possibilidades de interação com '
        'as obras expostas.',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Texto curatorial'),
      ),
      body: SafeArea(
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemBuilder: (context, index) {
              final paragraph = _paragraphs[index];
              return Semantics(
                readOnly: true,
                child: SelectableText(
                  paragraph,
                  textAlign: TextAlign.justify,
                  style: theme.textTheme.bodyLarge,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemCount: _paragraphs.length,
          ),
        ),
      ),
    );
  }
}
