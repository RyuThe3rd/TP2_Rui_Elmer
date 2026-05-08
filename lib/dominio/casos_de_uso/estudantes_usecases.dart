import '../contratos/estudante_repository.dart';
import '../entidades/estudante.dart';

class EstudantesUseCases {
  final EstudanteRepository repository;
  EstudantesUseCases(this.repository);

  Future<void> criarOuEditar(Estudante estudante) async {
    if (estudante.nome.trim().isEmpty) {
      throw Exception('Nome do estudante é obrigatório.');
    }
    if (estudante.numero.trim().isEmpty) {
      throw Exception('Número do estudante é obrigatório.');
    }
    await repository.salvar(estudante);
  }

  Future<void> remover(String id) => repository.remover(id);
  Future<List<Estudante>> listar() => repository.listar();
}
