enum TipoAvaliacao { teste, trabalho, exame, projeto }

class Avaliacao {
  final String id;
  final String disciplinaId;
  final String titulo;
  final TipoAvaliacao tipo;
  final double peso;

  const Avaliacao({
    required this.id,
    required this.disciplinaId,
    required this.titulo,
    required this.tipo,
    required this.peso,
  });

  Avaliacao copyWith({
    String? id,
    String? disciplinaId,
    String? titulo,
    TipoAvaliacao? tipo,
    double? peso,
  }) {
    return Avaliacao(
      id: id ?? this.id,
      disciplinaId: disciplinaId ?? this.disciplinaId,
      titulo: titulo ?? this.titulo,
      tipo: tipo ?? this.tipo,
      peso: peso ?? this.peso,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'disciplinaId': disciplinaId,
        'titulo': titulo,
        'tipo': tipo.name,
        'peso': peso,
      };

  factory Avaliacao.fromMap(Map<String, dynamic> map) {
    return Avaliacao(
      id: map['id'] ?? '',
      disciplinaId: map['disciplinaId'] ?? '',
      titulo: map['titulo'] ?? '',
      tipo: TipoAvaliacao.values.firstWhere(
        (t) => t.name == map['tipo'],
        orElse: () => TipoAvaliacao.teste,
      ),
      peso: (map['peso'] ?? 0).toDouble(),
    );
  }
}
