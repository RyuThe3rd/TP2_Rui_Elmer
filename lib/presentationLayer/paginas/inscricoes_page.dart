import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2_rui_elmer/dominio/entidades/enums.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/DisciplinaProvider.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/EstudanteProvider.dart';


class InscricoesPage extends StatelessWidget {
  const InscricoesPage({super.key});

  String _data(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _abrirFormulario(BuildContext context) async {
    final discProvider = context.read<DisciplinaProvider>();
    final estProvider = context.read<EstudanteProvider>();
    
    if (estProvider.estudantes.isEmpty || discProvider.disciplinas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre estudantes e disciplinas primeiro.')),
      );
      return;
    }

    String estudanteId = estProvider.estudantes.first.id;
    String disciplinaId = discProvider.disciplinas.first.id;

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
              color: Color.fromARGB(255, 248, 250, 252),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SafeArea(
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
                  const Text('Nova inscrição', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: estudanteId,
                    decoration: const InputDecoration(labelText: 'Estudante', prefixIcon: Icon(Icons.person_outline)),
                    items: estProvider.estudantes
                        .map((e) => DropdownMenuItem(value: e.id, child: Text(e.nome+' '+e.apelido)))
                        .toList(),
                    onChanged: (value) => setSheetState(() => estudanteId = value ?? estudanteId),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: disciplinaId,
                    decoration: const InputDecoration(labelText: 'Disciplina', prefixIcon: Icon(Icons.menu_book_outlined)),
                    items: discProvider.disciplinas
                        .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome)))
                        .toList(),
                    onChanged: (value) => setSheetState(() => disciplinaId = value ?? disciplinaId),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.how_to_reg_outlined),
                      label: const Text('Inscrever estudante'),
                      onPressed: () async {
                        try {
                          await discProvider.inscreverEstudante(estudanteId, disciplinaId);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DisciplinaProvider>(
      builder: (context, provider, _) {
        final List<_InscricaoView> todasInscricoes = [];
        for (var d in provider.disciplinas) {
          for (var e in d.alunos) {
            todasInscricoes.add(_InscricaoView(estudante: e, disciplina: d));
          }
        }

        return Scaffold(
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color.fromARGB(255, 6, 78, 59), Color.fromARGB(255, 5, 150, 105)]),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.how_to_reg_outlined, color: Colors.white, size: 38),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Inscrições', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text('${todasInscricoes.length} inscrição(ões)', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (todasInscricoes.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: Text('Nenhuma inscrição feita.', style: TextStyle(color: Colors.black54))),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = todasInscricoes[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 8))],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            leading: const CircleAvatar(
                              backgroundColor: Color.fromARGB(255, 209, 250, 229),
                              child: Icon(Icons.check_circle_outline, color: Color.fromARGB(255, 4, 120, 87)),
                            ),
                            title: Text(item.estudante.nome +' '+ item.estudante.apelido, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(item.disciplina.nome),
                            ),
                          ),
                        );
                      },
                      childCount: todasInscricoes.length,
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _abrirFormulario(context),
            icon: const Icon(Icons.add),
            label: const Text('Inscrição'),
          ),
        );
      },
    );
  }
}

class _InscricaoView {
  final Estudante estudante;
  final Disciplina disciplina;
  _InscricaoView({required this.estudante, required this.disciplina});
}
