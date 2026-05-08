class Disciplina {
  final String id;
  final String nome;
  final String codigo;
  final String descricao;

  const Disciplina({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.descricao,
  });

  Disciplina copyWith({String? id, String? nome, String? codigo, String? descricao}) {
    return Disciplina(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      codigo: codigo ?? this.codigo,
      descricao: descricao ?? this.descricao,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'codigo': codigo,
        'descricao': descricao,
      };

  factory Disciplina.fromMap(Map<String, dynamic> map) {
    return Disciplina(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      codigo: map['codigo'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }
}
