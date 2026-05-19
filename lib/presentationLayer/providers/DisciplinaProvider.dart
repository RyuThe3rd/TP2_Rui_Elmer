import 'package:flutter/material.dart';
import 'package:tp2_rui_elmer/dominio/casosDeUso/criarDisciplina.dart';
import 'package:tp2_rui_elmer/dominio/casosDeUso/editarDisciplina.dart';
import 'package:tp2_rui_elmer/dominio/casosDeUso/inscreverEstudante.dart';
import 'package:tp2_rui_elmer/dominio/contratos/disciplinaContrato.dart';
import 'package:tp2_rui_elmer/dominio/contratos/estudanteContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';

class DisciplinaProvider extends ChangeNotifier {
  final DisciplinaContrato _repo;
  final EstudanteContrato _estudanteRepo;
  
  List<Disciplina> disciplinas = [];
  bool carregando = false;

  DisciplinaProvider(this._repo, this._estudanteRepo) {
    carregar();
  }

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();
    disciplinas = await _repo.listar();
    carregando = false;
    notifyListeners();
  }

  Future<void> salvar(Disciplina d) async {
    if (d.id == '-1' || d.id.isEmpty) {
      await CriarDisciplina(_repo).executar(
        nome: d.nome,
        curso: d.curso,
        descricao: d.descricao,
      );
    } else {
      await EditarDisciplina(_repo).executar(
        id: d.id,
        nome: d.nome,
        curso: d.curso,
        descricao: d.descricao,
      );
    }
    await carregar();
  }

  Future<void> remover(String id) async {
    await _repo.remover(id);
    await carregar();
  }

  Future<void> inscreverEstudante(String estudanteId, String disciplinaId) async {
    await InscreverEstudanteEmDisciplina(_estudanteRepo, _repo)
        .inscrever(estudanteId, disciplinaId);
    await carregar();
  }
}
