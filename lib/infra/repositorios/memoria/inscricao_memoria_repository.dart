import '../../../dominio/contratos/inscricao_repository.dart';
import '../../../dominio/entidades/inscricao.dart';

class InscricaoMemoriaRepository implements InscricaoRepository {
  final Map<String, Inscricao> _dados = {};

  @override
  Future<void> salvar(Inscricao inscricao) async {
    _dados[inscricao.id] = inscricao;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<Inscricao>> listar() async {
    return _dados.values.toList();
  }

  @override
  Future<bool> estudanteInscrito(String estudanteId, String disciplinaId) async {
    return _dados.values.any(
      (i) => i.estudanteId == estudanteId && i.disciplinaId == disciplinaId,
    );
  }
}
