import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2_rui_elmer/dominio/entidades/enums.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/DisciplinaProvider.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/EstudanteProvider.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/AvaliacaoProvider.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  String? disciplinaFiltro;
  String? estudanteFiltro;

  Color _corNota(double nota) {
    if (nota >= 14) return const Color(0xFF059669);
    if (nota >= 10) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    final avaProv = context.watch<AvaliacaoProvider>();
    final estProv = context.watch<EstudanteProvider>();
    final discProv = context.watch<DisciplinaProvider>();

    final avaliacoes = avaProv.avaliacoes.where((a) {
      final filtroDisc = disciplinaFiltro == null || a.disciplinaId == disciplinaFiltro;
      final filtroEst = estudanteFiltro == null || a.estudanteId == estudanteFiltro;
      return filtroDisc && filtroEst;
    }).toList();

    double mediaGeral = 0;
    if (avaliacoes.isNotEmpty) {
      mediaGeral = avaliacoes.map((a) => a.nota).reduce((a, b) => a + b) / avaliacoes.length;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Painel de Notas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _CardResumo(titulo: 'Média', valor: mediaGeral.toStringAsFixed(1)),
                const SizedBox(width: 10),
                _CardResumo(titulo: 'Lançamentos', valor: '${avaliacoes.length}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                DropdownButtonFormField<String?>(
                  value: disciplinaFiltro,
                  decoration: const InputDecoration(labelText: 'Filtrar Disciplina'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todas')),
                    ...discProv.disciplinas.map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome)))
                  ],
                  onChanged: (v) => setState(() => disciplinaFiltro = v),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  value: estudanteFiltro,
                  decoration: const InputDecoration(labelText: 'Filtrar Estudante'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos')),
                    ...estProv.estudantes.map((e) => DropdownMenuItem(value: e.id, child: Text(e.nome+' '+e.apelido)))
                  ],
                  onChanged: (v) => setState(() => estudanteFiltro = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: avaliacoes.length,
              itemBuilder: (context, i) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: _corNota(avaliacoes[i].nota).withOpacity(0.1),
                  child: Text(avaliacoes[i].nota.toStringAsFixed(0), style: TextStyle(color: _corNota(avaliacoes[i].nota))),
                ),
                title: Text(avaliacoes[i].estudante),
                subtitle: Text(avaProv.getNomeDisciplina(avaliacoes[i].disciplinaId)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardResumo extends StatelessWidget {
  final String titulo;
  final String valor;
  const _CardResumo({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.blue.shade900, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(valor, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(titulo, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
