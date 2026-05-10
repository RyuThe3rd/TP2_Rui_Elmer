import 'package:flutter/material.dart';
import 'package:tp2_rui_elmer/dataLayer/repositorios/avaliacao_ram_repositorio.dart';
import 'package:tp2_rui_elmer/dataLayer/repositorios/disciplina_ram_repositorio.dart';
import 'package:tp2_rui_elmer/dataLayer/repositorios/estudante_ram_repository.dart';
import 'package:tp2_rui_elmer/presentationLayer/paginas/app.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/AvaliacaoProvider.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/DisciplinaProvider.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/EstudanteProvider.dart';
import 'package:provider/provider.dart';

void main() {
  //clean architecture pura não me parece ser tão prático tbh

  final estudanteRepo = EstudanteRamImpl();
  final disciplinaRepo = DisciplinaRamImpl();
  final avaliacaoRepo = AvaliacaoRamImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EstudanteProvider(estudanteRepo)),

        ChangeNotifierProvider(create: (_) => DisciplinaProvider(disciplinaRepo, estudanteRepo)),

        ChangeNotifierProxyProvider2<EstudanteProvider, DisciplinaProvider, AvaliacaoProvider>(
            create: (_) => AvaliacaoProvider(avaliacaoRepo),
            //é uma callback funvtion
            update: (_, estudanteProv, disciplinaProv, avaliacaoProv) {
              return avaliacaoProv!
                ..atualizarDados(estudanteProv.estudantes, disciplinaProv.disciplinas);
            }),
      ],
      child: const GestaoEscolarApp(),
    ),
  );

}
