import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class EstudanteModelo extends Estudante {

   EstudanteModelo({
    super.id,
    required super.nome,
    required super.apelido,
    required super.curso,
    required super.dataDeInscricao,
    required super.turma,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'apelido': apelido,
    'dataDeInscricao': dataDeInscricao.toIso8601String(),
    'curso': curso,
    'turma': turma,
  };

  factory EstudanteModelo.fromMap(Map<String, dynamic> map) {
    return EstudanteModelo(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      dataDeInscricao: DateTime.parse(map['dataDeInscricao'] ) ?? DateTime.now(),
      turma: map['turma'] ?? '',
      apelido: map['apelido'] ?? '',
      curso: map['curso'] ?? '',
    );
  }
}
