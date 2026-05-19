

import 'package:tp2_rui_elmer/dominio/entidades/enums.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class Disciplina{

  static final List<Disciplina> disciplinas = [];
  final List<Estudante> _alunos = [];

  String? _id;
  String? _nome;
  DateTime _dataDeCriacao;
  String _curso;
  String? _descricao;

  Disciplina({
    String? id,
    required String nome,
    required DateTime dataDeCriacao,
    required String curso,
  String? descricao
  }):
      _descricao = descricao,
      _id = id,
        _nome = nome,
        this._dataDeCriacao = dataDeCriacao,
        this._curso = curso
  ;


  String get descricao => _descricao ?? '';

  set descricao(String value) {
    _descricao = value;
  }

  String get curso => _curso;

  set curso(String value) {
    _curso = value;
  }

  DateTime get dataDeCriacao => _dataDeCriacao;

  set dataDeCriacao(DateTime value) {
    _dataDeCriacao = value;
  }

  String get nome => _nome ?? '-1';

  List<Estudante> get alunos => _alunos;

  set nome(String value) {
    _nome = value;
  }

  String get id => _id ?? '-1';

  set id(String value) {
    _id = value;
  }
}
