

class Disciplina{

  static final List<Disciplina> disciplinas = [];

  String? _id;
  String? _nome;
  DateTime _dataDeCriacao;
  String _curso;

  Disciplina({required String nome,
    required DateTime dataDeCriacao,
    required String curso}):
        _nome = nome,
        this._dataDeCriacao = dataDeCriacao,
        this._curso = curso
  ;

  String get curso => _curso;

  set curso(String value) {
    _curso = value;
  }

  DateTime get dataDeCriacao => _dataDeCriacao;

  set dataDeCriacao(DateTime value) {
    _dataDeCriacao = value;
  }

  String get nome => _nome!;

  set nome(String value) {
    _nome = value;
  }

  String get id => _id ?? 'ainda não foi gravado';

  set id(String value) {
    _id = value;
  }


}