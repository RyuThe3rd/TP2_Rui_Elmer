class Inscricao {
  final String id;
  final String estudanteId;
  final String disciplinaId;
  final DateTime dataInscricao;

  const Inscricao({
    required this.id,
    required this.estudanteId,
    required this.disciplinaId,
    required this.dataInscricao,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'estudanteId': estudanteId,
        'disciplinaId': disciplinaId,
        'dataInscricao': dataInscricao.toIso8601String(),
      };

  factory Inscricao.fromMap(Map<String, dynamic> map) {
    return Inscricao(
      id: map['id'] ?? '',
      estudanteId: map['estudanteId'] ?? '',
      disciplinaId: map['disciplinaId'] ?? '',
      dataInscricao: DateTime.tryParse(map['dataInscricao'] ?? '') ?? DateTime.now(),
    );
  }
}
