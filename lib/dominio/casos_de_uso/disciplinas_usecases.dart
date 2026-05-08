import '../contratos/disciplina_repository.dart';
import '../entidades/disciplina.dart';

class DisciplinasUseCases {
  final DisciplinaRepository repository;
  DisciplinasUseCases(this.repository);

  Future<void> criarOuEditar(Disciplina disciplina) async {
    if (disciplina.nome.trim().isEmpty) {
      throw Exception('Nome da disciplina é obrigatório.');
    }
    if (disciplina.codigo.trim().isEmpty) {
      throw Exception('Código da disciplina é obrigatório.');
    }
    await repository.salvar(disciplina);
  }

  Future<void> remover(String id) => repository.remover(id);
  Future<List<Disciplina>> listar() => repository.listar();
}
