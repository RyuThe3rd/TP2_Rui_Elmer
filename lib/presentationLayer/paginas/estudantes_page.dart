import 'package:flutter/material.dart';

import '../../dominio/entidades/estudante.dart';
import '../controllers/gestao_escolar_controller.dart';

class EstudantesPage extends StatefulWidget {
  final GestaoEscolarController controller;

  const EstudantesPage({super.key, required this.controller});

  @override
  State<EstudantesPage> createState() => _EstudantesPageState();
}

class _EstudantesPageState extends State<EstudantesPage> {
  final TextEditingController _pesquisaController = TextEditingController();
  String pesquisa = '';

  final List<String> cursos = const ['LECC', 'LEIT', 'OUTROS'];

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  String _iniciais(String nome) {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return 'E';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
  }

  Future<void> _abrirFormulario(BuildContext context, Estudante? estudante) async {
    final nomeController = TextEditingController(text: estudante?.nome ?? '');
    final apelidoController = TextEditingController(text: estudante?.apelido ?? '');
    final turmaController = TextEditingController(text: estudante?.turma ?? '');
    String curso = estudante?.curso ?? cursos.first;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
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
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBEAFE),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                estudante == null ? 'Cadastrar estudante' : 'Editar estudante',
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Preencha os dados académicos do estudante.',
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 22),
                        TextField(
                          controller: nomeController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: apelidoController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Apelido',
                            prefixIcon: Icon(Icons.person_2_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: curso,
                          decoration: const InputDecoration(
                            labelText: 'Curso',
                            prefixIcon: Icon(Icons.school_outlined),
                          ),
                          items: cursos
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (value) {
                            setSheetState(() => curso = value ?? curso);
                          },
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: turmaController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Turma',
                            prefixIcon: Icon(Icons.groups_2_outlined),
                            hintText: 'Ex: LECC-1A',
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.save_outlined),
                            label: const Text('Guardar estudante'),
                            onPressed: () async {
                              final nome = nomeController.text.trim();
                              final apelido = apelidoController.text.trim();
                              final turma = turmaController.text.trim();

                              if (nome.isEmpty || apelido.isEmpty || turma.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Preencha todos os campos.')),
                                );
                                return;
                              }

                              try {
                                await widget.controller.salvarEstudante(
                                  Estudante(
                                    id: estudante?.id,
                                    nome: nome,
                                    apelido: apelido,
                                    curso: curso,
                                    turma: turma,
                                    dataDeInscricao: estudante?.dataDeInscricao ?? DateTime.now(),
                                  ),
                                );

                                if (sheetContext.mounted) Navigator.pop(sheetContext);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmarRemocao(BuildContext context, Estudante estudante) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Remover estudante'),
        content: Text('Tens certeza que desejas remover ${estudante.nomeCompleto}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Remover'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await widget.controller.removerEstudante(estudante.id);
    }
  }

  Widget _cardResumo(IconData icon, String titulo, String valor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 10),
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(titulo, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _estadoVazio() {
    return const Padding(
      padding: EdgeInsets.only(top: 70),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 70, color: Colors.black26),
            SizedBox(height: 14),
            Text(
              'Nenhum estudante encontrado',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 6),
            Text('Clique em “Novo estudante” para cadastrar.', style: TextStyle(color: Colors.black45)),
          ],
        ),
      ),
    );
  }

  Widget _cardEstudante(BuildContext context, Estudante estudante) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFFDBEAFE),
              child: Text(
                _iniciais(estudante.nomeCompleto),
                style: const TextStyle(
                  color: Color(0xFF1E40AF),
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    estudante.nomeCompleto,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.groups_2_outlined, size: 16, color: Colors.black45),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Turma ${estudante.turma}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      estudante.curso,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onSelected: (value) {
                if (value == 'editar') _abrirFormulario(context, estudante);
                if (value == 'remover') _confirmarRemocao(context, estudante);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'editar',
                  child: Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 8), Text('Editar')]),
                ),
                PopupMenuItem(
                  value: 'remover',
                  child: Row(children: [Icon(Icons.delete_outline, color: Colors.red), SizedBox(width: 8), Text('Remover')]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final estudantes = widget.controller.estudantes;
        final estudantesFiltrados = estudantes.where((estudante) {
          final texto = '${estudante.nomeCompleto} ${estudante.turma} ${estudante.curso}'.toLowerCase();
          return texto.contains(pesquisa.toLowerCase());
        }).toList();
        final totalCursos = estudantes.map((e) => e.curso).toSet().length;

        return Scaffold(
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1D4ED8), Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.school_outlined, color: Colors.white, size: 30),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Gestão de Estudantes',
                              style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text('Cadastro académico dos estudantes', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _cardResumo(Icons.people_alt_outlined, 'Estudantes', '${estudantes.length}'),
                          const SizedBox(width: 12),
                          _cardResumo(Icons.menu_book_outlined, 'Cursos', '$totalCursos'),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _pesquisaController,
                        onChanged: (value) => setState(() => pesquisa = value),
                        decoration: InputDecoration(
                          hintText: 'Pesquisar por nome, turma ou curso...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: pesquisa.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _pesquisaController.clear();
                                    setState(() => pesquisa = '');
                                  },
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (estudantesFiltrados.isEmpty)
                SliverToBoxAdapter(child: _estadoVazio())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _cardEstudante(context, estudantesFiltrados[index]),
                      childCount: estudantesFiltrados.length,
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _abrirFormulario(context, null),
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Novo estudante'),
          ),
        );
      },
    );
  }
}
