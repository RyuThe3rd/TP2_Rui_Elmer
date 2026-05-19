import 'package:flutter/material.dart';
import 'package:tp2_rui_elmer/dataLayer/models/EstudanteModelo.dart';
import 'package:tp2_rui_elmer/dominio/casosDeUso/criarEstudante.dart';
import 'package:tp2_rui_elmer/dominio/casosDeUso/editarEstudante.dart';
import 'package:tp2_rui_elmer/dominio/contratos/estudanteContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class EstudanteProvider extends ChangeNotifier {
  final EstudanteContrato _repo;
  List<Estudante> estudantes = [];
  bool carregando = false;

  EstudanteProvider(this._repo) {
    carregar();
  }

  Future<void> carregar() async {
    carregando = true;
    notifyListeners();
    estudantes = await _repo.listar(true);
    carregando = false;
    notifyListeners();
  }

  Future<void> salvar(Estudante e) async {
    if (e.id == '-1' || e.id.isEmpty) {
      await CriarEstudante(_repo).executar(nome: e.nome,
          apelido: e.apelido, turma: e.turma, curso: e.curso);
    } else {
      await EditarEstudante(_repo).executar(estudanteId: e.id,
          nome: e.nome, apelido: e.apelido, turma: e.turma, curso: e.curso);
    }
    await carregar();
  }

  Future<void> remover(String id) async {
    await _repo.remover(id);
    await carregar();
  }
}