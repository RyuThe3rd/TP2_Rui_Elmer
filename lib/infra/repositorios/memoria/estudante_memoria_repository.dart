import '../../../dominio/contratos/estudante_repository.dart';
import '../../../dominio/entidades/estudante.dart';

class EstudanteMemoriaRepository implements EstudanteRepository {
  final Map<String, Estudante> _dados = {};

  @override
  Future<void> salvar(Estudante estudante) async {
    _dados[estudante.id] = estudante;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<Estudante>> listar() async {
    final lista = _dados.values.toList();
    lista.sort((a, b) => a.nome.compareTo(b.nome));
    return lista;
  }

  @override
  Future<Estudante?> buscarPorId(String id) async => _dados[id];
}
