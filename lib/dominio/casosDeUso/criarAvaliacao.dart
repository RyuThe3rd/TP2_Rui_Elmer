import '../contratos/avaliacaoContrato.dart';
import '../entidades/avaliacao.dart';
import '../entidades/enums.dart';

class CriarAvaliacao {
  final AvaliacaoContrato _repositorio;
  CriarAvaliacao(this._repositorio);

  Future<Avaliacao> executar({
    required Avaliacoes tipo,
    required String estudante,
    required String estudanteId,
    required String disciplinaId,
    required double nota,
  }) async {
    final avaliacao = Avaliacao(
      tipo: tipo,
      estudante: estudante,
      estudanteId: estudanteId,
      data: DateTime.now(),
      disciplinaId: disciplinaId,
      nota: nota,
    );
    await _repositorio.salvar(avaliacao);
    return avaliacao;
  }
}
