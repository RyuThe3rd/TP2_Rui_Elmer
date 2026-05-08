import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gestao_notas_provider.dart';

class InscricoesPage extends StatefulWidget {
  const InscricoesPage({super.key});

  @override
  State<InscricoesPage> createState() => _InscricoesPageState();
}

class _InscricoesPageState extends State<InscricoesPage> {
  String? estudanteId;
  String? disciplinaId;

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
                          onChanged: (value) => setState(() => disciplinaId = value),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: estudanteId == null || disciplinaId == null
                              ? null
                              : () async {
                                  try {
                                    await provider.inscreverEstudante(estudanteId!, disciplinaId!);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Inscrição feita com sucesso.')),
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
                          icon: const Icon(Icons.person_add),
                          label: const Text('Inscrever estudante'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: provider.inscricoes.isEmpty
                      ? const Center(child: Text('Nenhuma inscrição feita.'))
                      : ListView.builder(
                          itemCount: provider.inscricoes.length,
                          itemBuilder: (context, index) {
                            final inscricao = provider.inscricoes[index];
                            return Card(
                              child: ListTile(
                                title: Text(provider.nomeEstudante(inscricao.estudanteId)),
                                subtitle: Text(provider.nomeDisciplina(inscricao.disciplinaId)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => provider.removerInscricao(inscricao.id),
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
