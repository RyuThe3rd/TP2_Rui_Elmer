import 'package:flutter/material.dart';

import 'avaliacoes_page.dart';
import 'disciplinas_page.dart';
import 'estudantes_page.dart';
import 'inscricoes_page.dart';
import 'notas_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestão de Notas de Estudantes'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Estudantes'),
              Tab(text: 'Disciplinas'),
              Tab(text: 'Avaliações'),
              Tab(text: 'Inscrições'),
              Tab(text: 'Notas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EstudantesPage(),
            DisciplinasPage(),
            AvaliacoesPage(),
            InscricoesPage(),
            NotasPage(),
          ],
        ),
      ),
    );
  }
}
