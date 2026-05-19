import '../entidades/avaliacao.dart';

abstract class AvaliacaoContrato {
  Future<void> salvar(Avaliacao avaliacao);
  Future<void> remover(String id);
  Future<List<Avaliacao>> listar();
  Future<List<Avaliacao>> listarPorDisciplina(String disciplinaId);
  Future<Avaliacao?> buscarPorId(String id);
}
