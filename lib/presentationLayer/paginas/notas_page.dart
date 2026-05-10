import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gestao_escolar_provider.dart';

class NotasPage extends StatefulWidget {
  const NotasPage({super.key});

  @override
  State<NotasPage> createState() => _NotasPageState();
}

class _NotasPageState extends State<NotasPage> {
  String? disciplinaFiltro;
  String? estudanteFiltro;

  Color _corNota(double nota) {
    if (nota >= 14) return const Color(0xFF059669);
    if (nota >= 10) return const Color(0xFFD97706);
    return const Color(0xFFDC2626);
  }

  double _media(List<double> notas) {
    if (notas.isEmpty) return 0;
    return notas.reduce((a, b) => a + b) / notas.length;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GestaoEscolarProvider>(
      builder: (context, provider, _) {
        final disciplinaValue = provider.disciplinas.any((d) => d.id == disciplinaFiltro) ? disciplinaFiltro : null;
        final estudanteValue = provider.estudantes.any((e) => e.id == estudanteFiltro) ? estudanteFiltro : null;

        final avaliacoes = provider.avaliacoes.where((a) {
          final filtroDisciplina = disciplinaValue == null || a.disciplinaId == disciplinaValue;
          final filtroEstudante = estudanteValue == null || a.estudanteId == estudanteValue;
          return filtroDisciplina && filtroEstudante;
        }).toList();

        final mediaGeral = _media(avaliacoes.map((a) => a.nota).toList());
        final aprovados = avaliacoes.where((a) => a.nota >= 10).length;

        return Scaffold(
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF581C87), Color(0xFF9333EA)]),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.grade_outlined, color: Colors.white, size: 36),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text('Painel de Notas', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _ResumoNotasCard(titulo: 'Média', valor: mediaGeral.toStringAsFixed(1), icon: Icons.trending_up),
                          const SizedBox(width: 12),
                          _ResumoNotasCard(titulo: 'Aprovados', valor: '$aprovados', icon: Icons.verified_outlined),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String?>(
                        value: disciplinaValue,
                        decoration: const InputDecoration(labelText: 'Filtrar por disciplina', prefixIcon: Icon(Icons.menu_book_outlined)),
                        items: [
                          const DropdownMenuItem<String?>(value: null, child: Text('Todas as disciplinas')),
                          ...provider.disciplinas.map((d) => DropdownMenuItem<String?>(value: d.id, child: Text(d.nome))),
                        ],
                        onChanged: (value) => setState(() => disciplinaFiltro = value),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String?>(
                        value: estudanteValue,
                        decoration: const InputDecoration(labelText: 'Filtrar por estudante', prefixIcon: Icon(Icons.person_outline)),
                        items: [
                          const DropdownMenuItem<String?>(value: null, child: Text('Todos os estudantes')),
                          ...provider.estudantes.map((e) => DropdownMenuItem<String?>(value: e.id, child: Text(e.nomeCompleto))),
                        ],
                        onChanged: (value) => setState(() => estudanteFiltro = value),
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
                    child: Center(child: Text('Nenhuma nota encontrada.', style: TextStyle(color: Colors.black54))),
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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, 8))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: _corNota(avaliacao.nota).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  avaliacao.nota.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: _corNota(avaliacao.nota),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(avaliacao.estudante, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 5),
                                    Text(provider.nomeDisciplina(avaliacao.disciplinaId), style: const TextStyle(color: Colors.black54)),
                                    const SizedBox(height: 5),
                                    Text(avaliacao.tipo.label, style: const TextStyle(color: Color(0xFF7E22CE), fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              Icon(
                                avaliacao.nota >= 10 ? Icons.check_circle_outline : Icons.error_outline,
                                color: _corNota(avaliacao.nota),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: avaliacoes.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ResumoNotasCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icon;

  const _ResumoNotasCard({
    required this.titulo,
    required this.valor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
            Text(valor, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
            Text(titulo, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
