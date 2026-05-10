import 'package:flutter/material.dart';
import 'package:tp2_rui_elmer/dominio/casosDeUso/calcularMediaPorDisciplina.dart';
import 'package:tp2_rui_elmer/dominio/casosDeUso/criarAvaliacao.dart';
import 'package:tp2_rui_elmer/dominio/contratos/avaliacaoContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/avaliacao.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';

class AvaliacaoProvider extends ChangeNotifier {
  final AvaliacaoContrato _repo;
  
  List<Avaliacao> avaliacoes = [];
  List<Estudante> _estudantes = [];
  List<Disciplina> _disciplinas = [];
  bool carregando = false;

  AvaliacaoProvider(this._repo) {
    carregar();
  }

  void atualizarDados(List<Estudante> estudantes, List<Disciplina> disciplinas) {
    _estudantes = estudantes;
    _disciplinas = disciplinas;
  }

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();
    avaliacoes = await _repo.listar();
    carregando = false;
    notifyListeners();
  }

  Future<void> salvar(Avaliacao a) async {
    await CriarAvaliacao(_repo).executar(
      tipo: a.tipo,
      estudante: a.estudante,
      estudanteId: a.estudanteId,
      disciplinaId: a.disciplinaId,
      nota: a.nota,
    );
    await carregar();
  }

  Future<void> remover(String id) async {
    await _repo.remover(id);
    await carregar();
  }

  Future<double> calcularMedia(String disciplinaId) async {
    return await CalcularMediaPorDisciplina(avaliacaoContrato: _repo)
        .calcularMedia(disciplinaId: disciplinaId);
  }

  String getNomeEstudante(String id) {
    try {
        final e = _estudantes.firstWhere((e) => e.id == id);
        return e.nome + ' ' + e.apelido;
    } catch (_) {
      return 'Estudante não encontrado';
    }
  }

  String getNomeDisciplina(String id) {
    try {
      return _disciplinas.firstWhere((d) => d.id == id).nome;
    } catch (_) {
      return 'Disciplina não encontrada';
    }
  }
}
