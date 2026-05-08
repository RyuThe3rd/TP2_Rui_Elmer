import '../../../dominio/contratos/avaliacao_repository.dart';
import '../../../dominio/entidades/avaliacao.dart';

class AvaliacaoMemoriaRepository implements AvaliacaoRepository {
  final Map<String, Avaliacao> _dados = {};

  @override
  Future<void> salvar(Avaliacao avaliacao) async {
    _dados[avaliacao.id] = avaliacao;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<Avaliacao>> listar() async {
    final lista = _dados.values.toList();
    lista.sort((a, b) => a.titulo.compareTo(b.titulo));
    return lista;
  }

  @override
  Future<List<Avaliacao>> listarPorDisciplina(String disciplinaId) async {
    return _dados.values.where((a) => a.disciplinaId == disciplinaId).toList();
  }

  @override
  Future<Avaliacao?> buscarPorId(String id) async => _dados[id];
}
