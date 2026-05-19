import 'package:flutter/material.dart';

import 'avaliacoes_page.dart';
import 'disciplinas_page.dart';
import 'estudantes_page.dart';
import 'inscricoes_page.dart';
import 'notas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sistema Escolar - Elmer & Rui',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Gestão académica',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(icon: Icon(Icons.people_alt_outlined), text: 'Estudantes'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Disciplinas'),
              Tab(icon: Icon(Icons.how_to_reg_outlined), text: 'Inscrições'),
              Tab(icon: Icon(Icons.assignment_outlined), text: 'Avaliações'),
              Tab(icon: Icon(Icons.grade_outlined), text: 'Notas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EstudantesPage(),
            DisciplinasPage(),
            InscricoesPage(),
            AvaliacoesPage(),
            NotasPage(),
          ],
        ),
      ),
    );
  }
}
