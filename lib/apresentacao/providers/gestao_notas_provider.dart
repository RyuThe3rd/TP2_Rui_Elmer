import 'package:flutter/material.dart';

import '../../dominio/casos_de_uso/avaliacoes_usecases.dart';
import '../../dominio/casos_de_uso/disciplinas_usecases.dart';
import '../../dominio/casos_de_uso/estudantes_usecases.dart';
import '../../dominio/casos_de_uso/inscricoes_usecases.dart';
import '../../dominio/casos_de_uso/notas_usecases.dart';
import '../../dominio/entidades/avaliacao.dart';
import '../../dominio/entidades/disciplina.dart';
import '../../dominio/entidades/estudante.dart';
import '../../dominio/entidades/inscricao.dart';
import '../../dominio/entidades/nota.dart';
import '../../infra/repositorios/memoria/avaliacao_memoria_repository.dart';
import '../../infra/repositorios/memoria/disciplina_memoria_repository.dart';
import '../../infra/repositorios/memoria/estudante_memoria_repository.dart';
import '../../infra/repositorios/memoria/inscricao_memoria_repository.dart';
import '../../infra/repositorios/memoria/nota_memoria_repository.dart';

class GestaoNotasProvider extends ChangeNotifier {
  final EstudantesUseCases estudantesUseCases;
  final DisciplinasUseCases disciplinasUseCases;
  final AvaliacoesUseCases avaliacoesUseCases;
  final InscricoesUseCases inscricoesUseCases;
  final NotasUseCases notasUseCases;

  GestaoNotasProvider({
    required this.estudantesUseCases,
    required this.disciplinasUseCases,
    required this.avaliacoesUseCases,
    required this.inscricoesUseCases,
    required this.notasUseCases,
  });

  factory GestaoNotasProvider.memoria() {
    final estudanteRepo = EstudanteMemoriaRepository();
    final disciplinaRepo = DisciplinaMemoriaRepository();
    final avaliacaoRepo = AvaliacaoMemoriaRepository();
    final inscricaoRepo = InscricaoMemoriaRepository();
    final notaRepo = NotaMemoriaRepository();

    return GestaoNotasProvider(
      estudantesUseCases: EstudantesUseCases(estudanteRepo),
      disciplinasUseCases: DisciplinasUseCases(disciplinaRepo),
      avaliacoesUseCases: AvaliacoesUseCases(avaliacaoRepo, disciplinaRepo),
      inscricoesUseCases: InscricoesUseCases(inscricaoRepo, estudanteRepo, disciplinaRepo),
      notasUseCases: NotasUseCases(notaRepo, inscricaoRepo, avaliacaoRepo),
    );
  }

  List<Estudante> estudantes = [];
  List<Disciplina> disciplinas = [];
  List<Avaliacao> avaliacoes = [];
  List<Inscricao> inscricoes = [];
  List<Nota> notas = [];

  String? erro;
  bool carregando = false;

  String gerarId() => DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> carregarTudo() async {
    carregando = true;
    erro = null;
    notifyListeners();
    try {
      estudantes = await estudantesUseCases.listar();
      disciplinas = await disciplinasUseCases.listar();
      avaliacoes = await avaliacoesUseCases.listar();
      inscricoes = await inscricoesUseCases.listar();
      notas = await notasUseCases.listar();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> salvarEstudante(Estudante estudante) async {
    await estudantesUseCases.criarOuEditar(estudante);
    await carregarTudo();
  }

  Future<void> removerEstudante(String id) async {
    await estudantesUseCases.remover(id);
    await carregarTudo();
  }

  Future<void> salvarDisciplina(Disciplina disciplina) async {
    await disciplinasUseCases.criarOuEditar(disciplina);
    await carregarTudo();
  }

  Future<void> removerDisciplina(String id) async {
    await disciplinasUseCases.remover(id);
    await carregarTudo();
  }

  Future<void> salvarAvaliacao(Avaliacao avaliacao) async {
    await avaliacoesUseCases.criarOuEditar(avaliacao);
    await carregarTudo();
  }

  Future<void> removerAvaliacao(String id) async {
    await avaliacoesUseCases.remover(id);
    await carregarTudo();
  }

  Future<void> inscreverEstudante(String estudanteId, String disciplinaId) async {
    final inscricao = Inscricao(
      id: gerarId(),
      estudanteId: estudanteId,
      disciplinaId: disciplinaId,
      dataInscricao: DateTime.now(),
    );
    await inscricoesUseCases.inscrever(inscricao);
    await carregarTudo();
  }

  Future<void> removerInscricao(String id) async {
    await inscricoesUseCases.remover(id);
    await carregarTudo();
  }

  Future<void> atribuirNota({
    required String estudanteId,
    required String disciplinaId,
    required String avaliacaoId,
    required double valor,
  }) async {
    final nota = Nota(
      id: '$estudanteId-$avaliacaoId',
      estudanteId: estudanteId,
      disciplinaId: disciplinaId,
      avaliacaoId: avaliacaoId,
      valor: valor,
    );
    await notasUseCases.atribuirNota(nota);
    await carregarTudo();
  }

  Future<void> removerNota(String id) async {
    await notasUseCases.remover(id);
    await carregarTudo();
  }

  List<Avaliacao> avaliacoesDaDisciplina(String disciplinaId) {
    return avaliacoes.where((a) => a.disciplinaId == disciplinaId).toList();
  }

  List<Nota> notasDaDisciplina(String disciplinaId) {
    return notas.where((n) => n.disciplinaId == disciplinaId).toList();
  }

  double mediaDaDisciplina(String disciplinaId) {
    final lista = notasDaDisciplina(disciplinaId);
    if (lista.isEmpty) return 0;
    final soma = lista.fold<double>(0, (total, nota) => total + nota.valor);
    return soma / lista.length;
  }

  String nomeEstudante(String id) {
    for (final estudante in estudantes) {
      if (estudante.id == id) return estudante.nome;
    }
    return 'Estudante removido';
  }

  String nomeDisciplina(String id) {
    for (final disciplina in disciplinas) {
      if (disciplina.id == id) return disciplina.nome;
    }
    return 'Disciplina removida';
  }

  String tituloAvaliacao(String id) {
    for (final avaliacao in avaliacoes) {
      if (avaliacao.id == id) return avaliacao.titulo;
    }
    return 'Avaliação removida';
  }
}
