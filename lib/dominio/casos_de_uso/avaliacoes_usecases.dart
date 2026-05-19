import '../contratos/avaliacao_repository.dart';
import '../contratos/disciplina_repository.dart';
import '../entidades/avaliacao.dart';

class AvaliacoesUseCases {
  final AvaliacaoRepository avaliacaoRepository;
  final DisciplinaRepository disciplinaRepository;

  AvaliacoesUseCases(this.avaliacaoRepository, this.disciplinaRepository);

  Future<void> criarOuEditar(Avaliacao avaliacao) async {
    if (avaliacao.titulo.trim().isEmpty) {
      throw Exception('Título da avaliação é obrigatório.');
    }
    if (avaliacao.peso <= 0) {
      throw Exception('Peso da avaliação deve ser maior que zero.');
    }
    final disciplina = await disciplinaRepository.buscarPorId(avaliacao.disciplinaId);
    if (disciplina == null) {
      throw Exception('A disciplina da avaliação não existe.');
    }
    await avaliacaoRepository.salvar(avaliacao);
  }

  Future<void> remover(String id) => avaliacaoRepository.remover(id);
  Future<List<Avaliacao>> listar() => avaliacaoRepository.listar();
  Future<List<Avaliacao>> listarPorDisciplina(String disciplinaId) =>
      avaliacaoRepository.listarPorDisciplina(disciplinaId);
}
