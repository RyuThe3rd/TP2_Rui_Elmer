import 'package:tp2_rui_elmer/dataLayer/models/DisciplinaModelo.dart';
import 'package:tp2_rui_elmer/dominio/entidades/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2_rui_elmer/dominio/entidades/avaliacao.dart';
import 'package:collection/collection.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';
import '../providers/AvaliacaoProvider.dart';
import '../providers/DisciplinaProvider.dart';
import '../providers/EstudanteProvider.dart';

class AvaliacoesPage extends StatelessWidget {
  const AvaliacoesPage({super.key});

  String _data(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Color _corNota(double nota) {
    if (nota >= 14) return const Color(0xFF059669);
    if (nota >= 10) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  Future<void> _abrirFormulario(BuildContext context, Avaliacao? avaliacao) async {
    final avaProv = context.read<AvaliacaoProvider>();
    final estProv = context.read<EstudanteProvider>();
    final discProv = context.read<DisciplinaProvider>();

    if (estProv.estudantes.isEmpty || discProv.disciplinas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre estudantes e disciplinas primeiro.')),
      );
      return;
    }

    final List<Disciplina> disciplinas = discProv.disciplinas;

    String disciplinaId = avaliacao?.disciplinaId ?? (disciplinas.isNotEmpty ? disciplinas.first.id : '');

    final disciplinaSelecionada = disciplinas.firstWhereOrNull(
          (d) => d.id == avaliacao?.disciplinaId,
    ) ?? disciplinas.firstOrNull;

   if (disciplinaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma disciplina encontrada.')),
      );
      return;
    }


    List<Estudante> estudantesDisponiveis = disciplinaSelecionada.alunos;

    if (estudantesDisponiveis.isEmpty && avaliacao == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Esta disciplina não possui alunos inscritos. Inscreva-os na aba de Disciplinas.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    String estudanteId = avaliacao?.estudanteId ?? (estudantesDisponiveis.isNotEmpty ? estudantesDisponiveis.first.id : '');
    Avaliacoes tipo = avaliacao?.tipo ?? Avaliacoes.mt1;
    final notaController = TextEditingController(text: avaliacao?.nota.toString() ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      avaliacao == null ? 'Lançar avaliação' : 'Editar avaliação',
                      style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: disciplinaId,
                      decoration: const InputDecoration(labelText: 'Disciplina'),
                      items: disciplinas
                          .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome)))
                          .toList(),
                      onChanged: (value) {
                        setSheetState(() {
                          disciplinaId = value ?? disciplinaId;
                          estudantesDisponiveis = disciplinas
                              .firstWhere((d) => d.id == disciplinaId).alunos;
                          if (estudantesDisponiveis.isNotEmpty) {
                            estudanteId = estudantesDisponiveis.first.id;
                          } else {
                            estudanteId = '';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: estudanteId.isEmpty ? null : estudanteId,
                      decoration: const InputDecoration(labelText: 'Estudante'),
                      items: estudantesDisponiveis
                          .map((e) => DropdownMenuItem(value: e.id, child: Text(e.nome+' '+e.apelido)))
                          .toList(),
                      onChanged: (value) => setSheetState(() => estudanteId = value ?? estudanteId),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<Avaliacoes>(
                      value: tipo,
                      decoration: const InputDecoration(labelText: 'Tipo de avaliação'),
                      items: Avaliacoes.values
                          .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                          .toList(),
                      onChanged: (value) => setSheetState(() => tipo = value ?? tipo),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: notaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Nota'),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          final nota = double.tryParse(notaController.text.trim().replaceAll(',', '.'));
                          if (nota == null) return;
                          if (estudanteId.isEmpty) return;

                          final estudante = estudantesDisponiveis.firstWhere((e) => e.id == estudanteId);

                          await avaProv.salvar(
                            Avaliacao(
                              id: avaliacao?.id ?? '-1',
                              tipo: tipo,
                              estudante: estudante.nome+' '+estudante.apelido,
                              estudanteId: estudanteId,
                              disciplinaId: disciplinaId,
                              nota: nota,
                              data: avaliacao?.data ?? DateTime.now(),
                            ),
                          );
                          if (sheetContext.mounted) Navigator.pop(sheetContext);
                        },
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AvaliacaoProvider>(
      builder: (context, provider, _) {
        final avaliacoes = provider.avaliacoes;

        return Scaffold(
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF7C2D12), Color(0xFFEA580C)]),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.assignment_outlined, color: Colors.white, size: 38),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Avaliações', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text('${avaliacoes.length} avaliação(ões) lançada(s)', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.carregando)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (avaliacoes.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: Text('Nenhuma avaliação lançada.', style: TextStyle(color: Colors.black54))),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final avaliacao = avaliacoes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 8))],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            leading: CircleAvatar(
                              backgroundColor: _corNota(avaliacao.nota).withOpacity(0.12),
                              child: Text(
                                avaliacao.nota.toStringAsFixed(0),
                                style: TextStyle(color: _corNota(avaliacao.nota), fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(avaliacao.estudante),
                            subtitle: Text('${provider.getNomeDisciplina(avaliacao.disciplinaId)} - ${avaliacao.tipo.label} • ${_data(avaliacao.data)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => provider.remover(avaliacao.id),
                            ),
                            onTap: () => _abrirFormulario(context, avaliacao),
                          ),
                        );
                      },
                      childCount: avaliacoes.length,
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _abrirFormulario(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Avaliação'),
          ),
        );
      },
    );
  }
}
