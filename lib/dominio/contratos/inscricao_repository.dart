import '../entidades/inscricao.dart';

abstract class InscricaoRepository {
  Future<void> salvar(Inscricao inscricao);
  Future<void> remover(String id);
  Future<List<Inscricao>> listar();
  Future<bool> estudanteInscrito(String estudanteId, String disciplinaId);
}
