import '../entidades/estudante.dart';

abstract class EstudanteRepository {
  Future<void> salvar(Estudante estudante);
  Future<void> remover(String id);
  Future<List<Estudante>> listar();
  Future<Estudante?> buscarPorId(String id);
}
