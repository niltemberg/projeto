# Exposição Acessível — Vozes do Tempo

Aplicativo Flutter com foco em acessibilidade digital para visitantes de uma exposição. A tela inicial reúne um vídeo de boas-vindas com interpretação em Libras e narração, além de atalhos para o texto curatorial e para a área de audiodescrições.

## Recursos principais

- Reprodução automática de vídeo acessível (Libras e áudio) na tela inicial.
- Botões com rótulos descritivos para acesso rápido ao texto curatorial e às audiodescrições.
- Tela com texto curatorial formatado para leitura confortável e suporte a leitores de tela.
- Tela de audiodescrições com campo numérico para o painel, feedback falado e visual, e lista das faixas disponíveis.
- Utilização de `Semantics`, mensagens faladas (`SemanticsService`) e componentes com alto contraste para garantir acessibilidade.

## Como executar

1. Instale o [Flutter](https://docs.flutter.dev/get-started/install) (SDK 3.10 ou superior).
2. No terminal, acesse esta pasta (`exposicao_acessivel`).
3. Execute `flutter pub get` para instalar as dependências.
4. Inicie o aplicativo com `flutter run` em um emulador ou dispositivo físico.

Os áudios e o vídeo utilizados são exemplos hospedados publicamente e podem ser substituídos por arquivos próprios da exposição.
