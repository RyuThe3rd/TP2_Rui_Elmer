import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';

class DisciplinaModelo extends Disciplina {

  DisciplinaModelo({
    super.id,
    required super.nome,
    required super.dataDeCriacao,
    required super.curso,
  super.descricao
  });


  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'dataDeCriacao': dataDeCriacao.toIso8601String(),
    'descricao': descricao,
  };

  factory DisciplinaModelo.fromMap(Map<String, dynamic> map) {
    return DisciplinaModelo(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      dataDeCriacao: DateTime.parse(map['dataDeCriacao'] ) ?? DateTime.now(),
      curso: map['curso'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }
}