class Estudante {
  final String id;
  final String nome;
  final String numero;
  final String curso;

  const Estudante({
    required this.id,
    required this.nome,
    required this.numero,
    required this.curso,
  });

  Estudante copyWith({String? id, String? nome, String? numero, String? curso}) {
    return Estudante(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      numero: numero ?? this.numero,
      curso: curso ?? this.curso,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'numero': numero,
        'curso': curso,
      };

  factory Estudante.fromMap(Map<String, dynamic> map) {
    return Estudante(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      numero: map['numero'] ?? '',
      curso: map['curso'] ?? '',
    );
  }
}
