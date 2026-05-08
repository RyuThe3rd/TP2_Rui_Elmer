import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dominio/entidades/estudante.dart';
import '../providers/gestao_notas_provider.dart';

class EstudantesPage extends StatelessWidget {
  const EstudantesPage({super.key});

  Future<void> _abrirFormulario(BuildContext context, Estudante? estudante) async {
    final provider = context.read<GestaoNotasProvider>();
    final nomeController = TextEditingController(text: estudante?.nome ?? '');
    final numeroController = TextEditingController(text: estudante?.numero ?? '');
    final cursoController = TextEditingController(text: estudante?.curso ?? '');

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(estudante == null ? 'Novo estudante' : 'Editar estudante'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome')),
              TextField(controller: numeroController, decoration: const InputDecoration(labelText: 'Número')),
              TextField(controller: cursoController, decoration: const InputDecoration(labelText: 'Curso')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              try {
                await provider.salvarEstudante(
                  Estudante(
                    id: estudante?.id ?? provider.gerarId(),
                    nome: nomeController.text.trim(),
                    numero: numeroController.text.trim(),
                    curso: cursoController.text.trim(),
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
          body: provider.estudantes.isEmpty
              ? const Center(child: Text('Nenhum estudante cadastrado.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.estudantes.length,
                  itemBuilder: (context, index) {
                    final estudante = provider.estudantes[index];
                    return Card(
                      child: ListTile(
                        title: Text(estudante.nome),
                        subtitle: Text('Número: ${estudante.numero} | Curso: ${estudante.curso}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _abrirFormulario(context, estudante),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => provider.removerEstudante(estudante.id),
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
            label: const Text('Estudante'),
          ),
        );
      },
    );
  }
}
