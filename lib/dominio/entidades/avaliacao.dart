
import 'package:tp2_rui_elmer/dominio/entidades/enums.dart';


class Avaliacao{
  String? _id;
  Avaliacoes _tipo;
  DateTime _data;
  String _estudante;
  String _estudanteId;
  String _disciplinaId;
  double _nota;

  Avaliacao({
    String? id,
    required Avaliacoes tipo,
    required String estudante,
    required String estudanteId,
    required DateTime data,
    required String disciplinaId,
    required double nota}):
        _id = id,
        _estudanteId = estudanteId,
        _tipo = tipo,
        _disciplinaId = disciplinaId,
        _data = data,
        _estudante = estudante,
        _nota = nota;

  double get nota => _nota;

  set nota(double value) {
    _nota = value;
  }

  String get disciplinaId => _disciplinaId;

  set disciplinaId(String value) {
    _disciplinaId = value;
  }

  String get estudanteId => _estudanteId;

  set estudanteId(String value) {
    _estudanteId = value;
  }

  String get estudante => _estudante;

  set estudante(String value) {
    _estudante = value;
  }

  DateTime get data => _data;

  set data(DateTime value) {
    _data = value;
  }

  Avaliacoes get tipo => _tipo;

  set tipo(Avaliacoes value) {
    _tipo = value;
  }

  //quando apanhar -1 lançar uma mensagem  lá na tela, de que não foi encontrado
  String get id => _id?? '-1';

  set id(String value) {
    _id = value;
  }


}
