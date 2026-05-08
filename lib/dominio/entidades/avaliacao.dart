
import 'dart:math';

enum Avaliacoes {
  ac,
  as,
  ap
}

class Avaliacao{

  static final List<Avaliacao> listaAvaliacoes = [];

  String? _id;
  Avaliacoes _tipo;
  DateTime _data;
  String _estudante;
  String _estudanteId;
  String _disciplina;
  double _nota;

  Avaliacao({required Avaliacoes tipo,
  required String estudante,
    required String estudanteId,
    required String disciplina,
  required double nota}):
      _estudanteId = estudanteId,
      _tipo = tipo,
  _disciplina = disciplina,
        _data = DateTime.now(),
        _estudante = estudante,
  _nota = nota;


}