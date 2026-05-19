import '../../../dominio/contratos/disciplina_repository.dart';
import '../../../dominio/entidades/disciplina.dart';

class DisciplinaMemoriaRepository implements DisciplinaRepository {
  final Map<String, Disciplina> _dados = {};

  @override
  Future<void> salvar(Disciplina disciplina) async {
    _dados[disciplina.id] = disciplina;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<Disciplina>> listar() async {
    final lista = _dados.values.toList();
    lista.sort((a, b) => a.nome.compareTo(b.nome));
    return lista;
  }

  @override
  Future<Disciplina?> buscarPorId(String id) async => _dados[id];
}
