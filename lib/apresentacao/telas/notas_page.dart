import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gestao_notas_provider.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  String? estudanteId;
  String? disciplinaId;
  String? avaliacaoId;
  final notaController = TextEditingController();

  @override
  void dispose() {
    notaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GestaoNotasProvider>(
      builder: (context, provider, _) {
        if (provider.estudantes.isEmpty) {
          estudanteId = null;
        } else if (!provider.estudantes.any((e) => e.id == estudanteId)) {
          estudanteId = provider.estudantes.first.id;
        }

        if (provider.disciplinas.isEmpty) {
          disciplinaId = null;
        } else if (!provider.disciplinas.any((d) => d.id == disciplinaId)) {
          disciplinaId = provider.disciplinas.first.id;
        }

        final avaliacoesFiltradas = disciplinaId == null
            ? provider.avaliacoes
            : provider.avaliacoesDaDisciplina(disciplinaId!);
        if (avaliacoesFiltradas.isNotEmpty && !avaliacoesFiltradas.any((a) => a.id == avaliacaoId)) {
          avaliacaoId = avaliacoesFiltradas.first.id;
        }
        if (avaliacoesFiltradas.isEmpty) avaliacaoId = null;

        final notasDisciplina = disciplinaId == null ? [] : provider.notasDaDisciplina(disciplinaId!);
        final media = disciplinaId == null ? 0 : provider.mediaDaDisciplina(disciplinaId!);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: estudanteId,
                          decoration: const InputDecoration(labelText: 'Estudante'),
                          items: provider.estudantes
                              .map((e) => DropdownMenuItem(value: e.id, child: Text(e.nome)))
                              .toList(),
                          onChanged: (value) => setState(() => estudanteId = value),
                        ),
                        DropdownButtonFormField<String>(
                          value: disciplinaId,
                          decoration: const InputDecoration(labelText: 'Disciplina'),
                          items: provider.disciplinas
                              .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome)))
                              .toList(),
                          onChanged: (value) => setState(() {
                            disciplinaId = value;
                            avaliacaoId = null;
                          }),
                        ),
                        DropdownButtonFormField<String>(
                          value: avaliacaoId,
                          decoration: const InputDecoration(labelText: 'Avaliação'),
                          items: avaliacoesFiltradas
                              .map((a) => DropdownMenuItem(value: a.id, child: Text(a.titulo)))
                              .toList(),
                          onChanged: (value) => setState(() => avaliacaoId = value),
                        ),
                        TextField(
                          controller: notaController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Nota 0 a 20'),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: estudanteId == null || disciplinaId == null || avaliacaoId == null
                              ? null
                              : () async {
                                  try {
                                    await provider.atribuirNota(
                                      estudanteId: estudanteId!,
                                      disciplinaId: disciplinaId!,
                                      avaliacaoId: avaliacaoId!,
                                      valor: double.tryParse(notaController.text.replaceAll(',', '.')) ?? -1,
                                    );
                                    notaController.clear();
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Nota atribuída com sucesso.')),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  }
                                },
                          icon: const Icon(Icons.grade),
                          label: const Text('Atribuir nota'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Média da disciplina: ${media.toStringAsFixed(2)} valores',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: notasDisciplina.isEmpty
                      ? const Center(child: Text('Nenhuma nota para esta disciplina.'))
                      : ListView.builder(
                          itemCount: notasDisciplina.length,
                          itemBuilder: (context, index) {
                            final nota = notasDisciplina[index];
                            return Card(
                              child: ListTile(
                                title: Text('${provider.nomeEstudante(nota.estudanteId)} - ${nota.valor} valores'),
                                subtitle: Text('Avaliação: ${provider.tituloAvaliacao(nota.avaliacaoId)}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => provider.removerNota(nota.id),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
