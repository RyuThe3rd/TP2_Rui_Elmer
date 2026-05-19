import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dominio/entidades/disciplina.dart';
import '../providers/gestao_notas_provider.dart';

class DisciplinasPage extends StatelessWidget {
  const DisciplinasPage({super.key});

  Future<void> _abrirFormulario(BuildContext context, Disciplina? disciplina) async {
    final provider = context.read<GestaoNotasProvider>();
    final nomeController = TextEditingController(text: disciplina?.nome ?? '');
    final codigoController = TextEditingController(text: disciplina?.codigo ?? '');
    final descricaoController = TextEditingController(text: disciplina?.descricao ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(disciplina == null ? 'Nova disciplina' : 'Editar disciplina'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: codigoController, decoration: const InputDecoration(labelText: 'Código')),
              TextField(controller: descricaoController, decoration: const InputDecoration(labelText: 'Descrição')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              try {
                await provider.salvarDisciplina(
                  Disciplina(
                    id: disciplina?.id ?? provider.gerarId(),
                    nome: nomeController.text.trim(),
                    codigo: codigoController.text.trim(),
                    descricao: descricaoController.text.trim(),
                  ),
                );
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } catch (e) {
                if (dialogContext.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GestaoNotasProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: provider.disciplinas.isEmpty
              ? const Center(child: Text('Nenhuma disciplina cadastrada.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.disciplinas.length,
                  itemBuilder: (context, index) {
                    final disciplina = provider.disciplinas[index];
                    return Card(
                      child: ListTile(
                        title: Text(disciplina.nome),
                        subtitle: Text('Código: ${disciplina.codigo}\n${disciplina.descricao}'),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _abrirFormulario(context, disciplina),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => provider.removerDisciplina(disciplina.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _abrirFormulario(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Disciplina'),
          ),
        );
      },
    );
  }
}
