
class Estudante {

  String? _id;
  String? _nome;
  String _apelido;
  DateTime _dataDeInscricao;
  String _turma;
  String _curso;

  String get id => _id ?? '-1';

  set id(String value) {
    _id = value;
  }

  Estudante({
    String? id,
    required String nome,
    required String apelido,
    required DateTime dataDeInscricao,
    required String turma,
    required String curso}):
      _id = id,
      _nome = nome,
        this._apelido = apelido,
        this._dataDeInscricao = dataDeInscricao,
        this._turma = turma,
        this._curso = curso
  ;

  String get nome => _nome!;

  String get curso => _curso;

  set curso(String value) {
    _curso = value;
  }

  String get turma => _turma;

  set turma(String value) {
    _turma = value;
  }

  DateTime get dataDeInscricao => _dataDeInscricao;

  set dataDeInscricao(DateTime value) {
    _dataDeInscricao = value;
  }

  String get apelido => _apelido;

  set apelido(String value) {
    _apelido = value;
  }

  set nome(String value) {
    _nome = value;
  }


}