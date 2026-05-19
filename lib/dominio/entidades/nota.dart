class Nota {
  final String id;
  final String estudanteId;
  final String disciplinaId;
  final String avaliacaoId;
  final double valor;

  const Nota({
    required this.id,
    required this.estudanteId,
    required this.disciplinaId,
    required this.avaliacaoId,
    required this.valor,
  });

  Nota copyWith({
    String? id,
    String? estudanteId,
    String? disciplinaId,
    String? avaliacaoId,
    double? valor,
  }) {
    return Nota(
      id: id ?? this.id,
      estudanteId: estudanteId ?? this.estudanteId,
      disciplinaId: disciplinaId ?? this.disciplinaId,
      avaliacaoId: avaliacaoId ?? this.avaliacaoId,
      valor: valor ?? this.valor,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'estudanteId': estudanteId,
        'disciplinaId': disciplinaId,
        'avaliacaoId': avaliacaoId,
        'valor': valor,
      };

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'] ?? '',
      estudanteId: map['estudanteId'] ?? '',
      disciplinaId: map['disciplinaId'] ?? '',
      avaliacaoId: map['avaliacaoId'] ?? '',
      valor: (map['valor'] ?? 0).toDouble(),
    );
  }
}
