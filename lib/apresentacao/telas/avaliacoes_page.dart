import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dominio/entidades/avaliacao.dart';
import '../providers/gestao_notas_provider.dart';

class AvaliacoesPage extends StatelessWidget {
  const AvaliacoesPage({super.key});

  Future<void> _abrirFormulario(BuildContext context, Avaliacao? avaliacao) async {
    final provider = context.read<GestaoNotasProvider>();
    if (provider.disciplinas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre uma disciplina primeiro.')),
      );
      return;
    }

    final tituloController = TextEditingController(text: avaliacao?.titulo ?? '');
    final pesoController = TextEditingController(text: avaliacao?.peso.toString() ?? '1');
    String disciplinaId = avaliacao?.disciplinaId ?? provider.disciplinas.first.id;
    TipoAvaliacao tipo = avaliacao?.tipo ?? TipoAvaliacao.teste;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: Text(avaliacao == null ? 'Nova avaliação' : 'Editar avaliação'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: disciplinaId,
                  decoration: const InputDecoration(labelText: 'Disciplina'),
                  items: provider.disciplinas
                      .map((d) => DropdownMenuItem(value: d.id, child: Text(d.nome)))
                      .toList(),
                  onChanged: (value) => setState(() => disciplinaId = value ?? disciplinaId),
                ),
                TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título')),
                DropdownButtonFormField<TipoAvaliacao>(
                  value: tipo,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: TipoAvaliacao.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                      .toList(),
                  onChanged: (value) => setState(() => tipo = value ?? tipo),
                ),
                TextField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                try {
                  await provider.salvarAvaliacao(
                    Avaliacao(
                      id: avaliacao?.id ?? provider.gerarId(),
                      disciplinaId: disciplinaId,
                      titulo: tituloController.text.trim(),
                      tipo: tipo,
                      peso: double.tryParse(pesoController.text.replaceAll(',', '.')) ?? 0,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GestaoNotasProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: provider.avaliacoes.isEmpty
              ? const Center(child: Text('Nenhuma avaliação cadastrada.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.avaliacoes.length,
                  itemBuilder: (context, index) {
                    final avaliacao = provider.avaliacoes[index];
                    return Card(
                      child: ListTile(
                        title: Text(avaliacao.titulo),
                        subtitle: Text(
                          'Disciplina: ${provider.nomeDisciplina(avaliacao.disciplinaId)} | Tipo: ${avaliacao.tipo.name} | Peso: ${avaliacao.peso}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _abrirFormulario(context, avaliacao),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => provider.removerAvaliacao(avaliacao.id),
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
            label: const Text('Avaliação'),
          ),
        );
      },
    );
  }
}
