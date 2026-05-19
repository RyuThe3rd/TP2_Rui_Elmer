import '../contratos/disciplina_repository.dart';
import '../contratos/estudante_repository.dart';
import '../contratos/inscricao_repository.dart';
import '../entidades/inscricao.dart';

class InscricoesUseCases {
  final InscricaoRepository inscricaoRepository;
  final EstudanteRepository estudanteRepository;
  final DisciplinaRepository disciplinaRepository;

  InscricoesUseCases(
    this.inscricaoRepository,
    this.estudanteRepository,
    this.disciplinaRepository,
  );

  Future<void> inscrever(Inscricao inscricao) async {
    final estudante = await estudanteRepository.buscarPorId(inscricao.estudanteId);
    if (estudante == null) {
      throw Exception('Estudante não encontrado.');
    }

    final disciplina = await disciplinaRepository.buscarPorId(inscricao.disciplinaId);
    if (disciplina == null) {
      throw Exception('Disciplina não encontrada.');
    }

    final jaInscrito = await inscricaoRepository.estudanteInscrito(
      inscricao.estudanteId,
      inscricao.disciplinaId,
    );
    if (jaInscrito) {
      throw Exception('Este estudante já está inscrito nesta disciplina.');
    }

    await inscricaoRepository.salvar(inscricao);
  }

  Future<void> remover(String id) => inscricaoRepository.remover(id);
  Future<List<Inscricao>> listar() => inscricaoRepository.listar();
}
