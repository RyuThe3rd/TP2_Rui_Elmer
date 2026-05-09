import '../entidades/estudante.dart';

abstract class EstudanteContrato {
  Future<void> salvar(Estudante estudante);
  Future<void> remover(String id);
  Future<List<Estudante>> listar(bool maisRecente);
  Future<Estudante?> buscarPorId(String id);
}
