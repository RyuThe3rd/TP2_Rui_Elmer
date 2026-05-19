
import 'package:tp2_rui_elmer/dominio/entidades/avaliacao.dart';
import 'package:tp2_rui_elmer/dominio/entidades/enums.dart';


class AvaliacaoModelo extends Avaliacao {

//Rui: super.parametro é a mesma coisa que named parameters normal
  AvaliacaoModelo ({
    super.id,
    required super.tipo,
    required super.estudante,
    required super.estudanteId,
    required super.data,
    required super.disciplinaId,
    required super.nota});


  Map<String, dynamic> toMap() => {
    'id': id,
    'disciplinaId': disciplinaId,
    'estudanteId': estudanteId,
    'tipo': tipo.name,
    'estudante': estudante,
    'data': data.toIso8601String(),
    'nota': nota,
  };

  factory AvaliacaoModelo.fromMap(Map<String, dynamic> map) {

    return AvaliacaoModelo(
      id: map['id'] ?? '',
      disciplinaId: map['disciplinaId'] ?? '',
      estudante: map['estudante'] ?? '',
      estudanteId: map['estudanteId'] ?? '',
      data: DateTime.parse(map['dataDeCriacao'] ) ?? DateTime.now(),
      nota: (map['nota'] as num).toDouble(),
      tipo: Avaliacoes.values.firstWhere(
            (t) => t.name == map['tipo'],
        orElse: () => Avaliacoes.mt1,
      ),
    );
  }

}