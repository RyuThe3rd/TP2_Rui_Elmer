import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2_rui_elmer/dominio/entidades/enums.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';
import 'package:tp2_rui_elmer/presentationLayer/providers/DisciplinaProvider.dart';

class DisciplinasPage extends StatefulWidget {
  const DisciplinasPage({super.key});

  @override
  State<DisciplinasPage> createState() => _DisciplinasPageState();
}

class _DisciplinasPageState extends State<DisciplinasPage> {
  final List<String> cursos = const ['LECC', 'LEIT', 'OUTROS'];

  Future<void> _abrirFormulario(BuildContext context, Disciplina? disciplina) async {
    final provider = context.read<DisciplinaProvider>();
    final nomeController = TextEditingController(text: disciplina?.nome ?? '');
    final descricaoController = TextEditingController(text: disciplina?.descricao ?? '');
    String curso = disciplina?.curso ?? cursos.first;

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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: const Color.fromARGB(255, 224, 231, 255), borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.menu_book_outlined, color: Color.fromARGB(255, 67, 56, 202)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            disciplina == null ? 'Cadastrar disciplina' : 'Editar disciplina',
                            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: nomeController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Nome da disciplina', prefixIcon: Icon(Icons.menu_book_outlined)),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: curso,
                      decoration: const InputDecoration(labelText: 'Curso', prefixIcon: Icon(Icons.school_outlined)),
                      items: cursos.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (value) => setSheetState(() => curso = value ?? curso),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descricaoController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Descrição', prefixIcon: Icon(Icons.description_outlined)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Guardar disciplina'),
                        onPressed: () async {
                          final nome = nomeController.text.trim();
                          if (nome.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informe o nome da disciplina.')));
                            return;
                          }
                          try {
                            await provider.salvar(
                              Disciplina(
                                id: disciplina?.id,
                                nome: nome,
                                curso: curso,
                                descricao: descricaoController.text.trim(),
                                dataDeCriacao: disciplina?.dataDeCriacao ?? DateTime.now(),
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

  Future<void> _remover(BuildContext context, Disciplina disciplina) async {
    final provider = context.read<DisciplinaProvider>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remover disciplina'),
        content: Text('Remover ${disciplina.nome}? Inscrições e avaliações ligadas também serão removidas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (ok == true) await provider.remover(disciplina.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DisciplinaProvider>(
      builder: (context, provider, _) {
        final disciplinas = provider.disciplinas;

        return Scaffold(
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color.fromARGB(255, 49, 46, 129),
                      Color.fromARGB(255, 79, 70, 229),
                    ]),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.menu_book_outlined, color: Colors.white, size: 38),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Disciplinas', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text('${disciplinas.length} disciplina(s) cadastrada(s)', style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (provider.carregando)
                const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              else if (disciplinas.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: Text('Nenhuma disciplina cadastrada.', style: TextStyle(color: Colors.black54))),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final disciplina = disciplinas[index];
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
                              backgroundColor: const Color.fromARGB(255, 224, 231, 255),
                              child: Text(disciplina.nome.isNotEmpty ? disciplina.nome[0].toUpperCase() : 'D'),
                            ),
                            title: Text(disciplina.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('${disciplina.curso}\n${disciplina.descricao.isEmpty ? 'Sem descrição' : disciplina.descricao}'),
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'editar') _abrirFormulario(context, disciplina);
                                if (value == 'remover') _remover(context, disciplina);
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(value: 'editar', child: Text('Editar')),
                                PopupMenuItem(value: 'remover', child: Text('Remover')),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: disciplinas.length,
                    ),
                  ),
                ),
            ],
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
