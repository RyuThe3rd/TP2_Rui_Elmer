import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dominio/entidades/avaliacao.dart';
import '../../dominio/entidades/disciplina.dart';
import '../../dominio/entidades/enums.dart';
import '../../dominio/entidades/estudante.dart';
import '../providers/gestao_escolar_provider.dart';

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
    final provider = context.read<GestaoEscolarProvider>();
    
    if (provider.estudantes.isEmpty || provider.disciplinas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre estudantes e disciplinas primeiro.')),
      );
      return;
    }

    final List<Disciplina> disciplinasComInscritos = provider.disciplinas;

    String disciplinaId = avaliacao?.disciplinaId ?? disciplinasComInscritos.first.id!;
    
    List<Estudante> estudantesDisponiveis = provider.estudantesInscritosNaDisciplina(disciplinaId);
    if (estudantesDisponiveis.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não há estudantes inscritos nesta disciplina.')),
        );
        return;
    }

    String estudanteId = avaliacao?.estudanteId ?? estudantesDisponiveis.first.id;
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
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      avaliacao == null ? 'Lançar avaliação' : 'Editar avaliação',
                      style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: disciplinaId,
                      decoration: const InputDecoration(labelText: 'Disciplina', prefixIcon: Icon(Icons.menu_book_outlined)),
                      items: disciplinasComInscritos
                          .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome)))
                          .toList(),
                      onChanged: (value) {
                        setSheetState(() {
                          disciplinaId = value ?? disciplinaId;
                          estudantesDisponiveis = provider.estudantesInscritosNaDisciplina(disciplinaId);
                          if (estudantesDisponiveis.isNotEmpty) {
                            estudanteId = estudantesDisponiveis.first.id;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: estudanteId,
                      decoration: const InputDecoration(labelText: 'Estudante', prefixIcon: Icon(Icons.person_outline)),
                      items: estudantesDisponiveis
                          .map((e) => DropdownMenuItem(value: e.id, child: Text(e.nomeCompleto)))
                          .toList(),
                      onChanged: (value) => setSheetState(() => estudanteId = value ?? estudanteId),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<Avaliacoes>(
                      value: tipo,
                      decoration: const InputDecoration(labelText: 'Tipo de avaliação', prefixIcon: Icon(Icons.assignment_outlined)),
                      items: Avaliacoes.values
                          .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
                          .toList(),
                      onChanged: (value) => setSheetState(() => tipo = value ?? tipo),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: notaController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Nota',
                        prefixIcon: Icon(Icons.grade_outlined),
                        hintText: '0 a 20',
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Guardar avaliação'),
                        onPressed: () async {
                          final nota = double.tryParse(notaController.text.trim().replaceAll(',', '.'));
                          if (nota == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe uma nota válida.')));
                            return;
                          }

                          final estudante = provider.estudantes.firstWhere((e) => e.id == estudanteId);

                          try {
                            await provider.salvarAvaliacao(
                              Avaliacao(
                                id: avaliacao?.id,
                                tipo: tipo,
                                estudante: estudante.nomeCompleto,
                                estudanteId: estudanteId,
                                disciplinaId: disciplinaId,
                                nota: nota,
                                data: avaliacao?.data ?? DateTime.now(),
                              ),
                            );
                            if (sheetContext.mounted) Navigator.pop(sheetContext);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                          }
                        },
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
    return Consumer<GestaoEscolarProvider>(
      builder: (context, provider, _) {
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
                            Text('${provider.avaliacoes.length} avaliação(ões) lançada(s)', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.carregando)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (provider.avaliacoes.isEmpty)
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
                        final avaliacao = provider.avaliacoes[index];
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
                            title: Text(avaliacao.estudante, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('${provider.nomeDisciplina(avaliacao.disciplinaId)}\n${avaliacao.tipo.label} • ${_data(avaliacao.data)}'),
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'editar') _abrirFormulario(context, avaliacao);
                                if (value == 'remover') provider.removerAvaliacao(avaliacao.id);
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: 'editar', child: Text('Editar')),
                                PopupMenuItem(value: 'remover', child: Text('Remover')),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: provider.avaliacoes.length,
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
