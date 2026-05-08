import '../../../dominio/contratos/nota_repository.dart';
import '../../../dominio/entidades/nota.dart';

class NotaMemoriaRepository implements NotaRepository {
  final Map<String, Nota> _dados = {};

  @override
  Future<void> salvar(Nota nota) async {
    _dados[nota.id] = nota;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<Nota>> listar() async => _dados.values.toList();

  @override
  Future<List<Nota>> listarPorDisciplina(String disciplinaId) async {
    return _dados.values.where((n) => n.disciplinaId == disciplinaId).toList();
  }

  @override
  Future<List<Nota>> listarPorEstudanteEDisciplina(String estudanteId, String disciplinaId) async {
    return _dados.values
        .where((n) => n.estudanteId == estudanteId && n.disciplinaId == disciplinaId)
        .toList();
  }
}
