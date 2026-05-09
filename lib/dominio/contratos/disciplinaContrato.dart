import '../entidades/disciplina.dart';

abstract class DisciplinaContrato {
  Future<void> salvar(Disciplina disciplina);
  Future<void> remover(String id);
  Future<List<Disciplina>> listar();
  Future<Disciplina?> buscarPorId(String id);
}
