import '../contratos/avaliacao_repository.dart';
import '../contratos/inscricao_repository.dart';
import '../contratos/nota_repository.dart';
import '../entidades/nota.dart';

class NotasUseCases {
  final NotaRepository notaRepository;
  final InscricaoRepository inscricaoRepository;
  final AvaliacaoRepository avaliacaoRepository;

  NotasUseCases(
    this.notaRepository,
    this.inscricaoRepository,
    this.avaliacaoRepository,
  );

  Future<void> atribuirNota(Nota nota) async {
    if (nota.valor < 0 || nota.valor > 20) {
      throw Exception('A nota deve estar entre 0 e 20 valores.');
    }

    final inscrito = await inscricaoRepository.estudanteInscrito(
      nota.estudanteId,
      nota.disciplinaId,
    );
    if (!inscrito) {
      throw Exception('Não é permitido atribuir nota: estudante não inscrito na disciplina.');
    }

    final avaliacao = await avaliacaoRepository.buscarPorId(nota.avaliacaoId);
    if (avaliacao == null || avaliacao.disciplinaId != nota.disciplinaId) {
      throw Exception('Avaliação inválida para esta disciplina.');
    }

    await notaRepository.salvar(nota);
  }

  Future<void> remover(String id) => notaRepository.remover(id);
  Future<List<Nota>> listar() => notaRepository.listar();
  Future<List<Nota>> listarPorDisciplina(String disciplinaId) =>
      notaRepository.listarPorDisciplina(disciplinaId);

  Future<double> mediaDaDisciplina(String disciplinaId) async {
    final notas = await notaRepository.listarPorDisciplina(disciplinaId);
    if (notas.isEmpty) return 0;
    final soma = notas.fold<double>(0, (total, nota) => total + nota.valor);
    return soma / notas.length;
  }

  Future<double> mediaDoEstudanteNaDisciplina(String estudanteId, String disciplinaId) async {
    final notas = await notaRepository.listarPorEstudanteEDisciplina(estudanteId, disciplinaId);
    if (notas.isEmpty) return 0;
    final soma = notas.fold<double>(0, (total, nota) => total + nota.valor);
    return soma / notas.length;
  }
}
