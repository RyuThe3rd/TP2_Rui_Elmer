import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class DisciplinaModelo extends Disciplina {
  DisciplinaModelo({
    super.id,
    required super.nome,
    required super.dataDeCriacao,
    required super.curso,
    super.descricao,
    List<Estudante>? alunosIniciais,
  }) {
    if (alunosIniciais != null) {
      alunos.addAll(alunosIniciais);
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nome': nome,
    'dataDeCriacao': dataDeCriacao.toIso8601String(),
    'descricao': descricao,
    'curso': curso,
  };

  // Para um repositório real, aqui converteríamos IDs de alunos em objetos ou vice-versa
}
