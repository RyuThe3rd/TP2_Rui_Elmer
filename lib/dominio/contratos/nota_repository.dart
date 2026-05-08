import '../entidades/nota.dart';

abstract class NotaRepository {
  Future<void> salvar(Nota nota);
  Future<void> remover(String id);
  Future<List<Nota>> listar();
  Future<List<Nota>> listarPorDisciplina(String disciplinaId);
  Future<List<Nota>> listarPorEstudanteEDisciplina(String estudanteId, String disciplinaId);
}
