import 'package:tp2_rui_elmer/dominio/contratos/estudanteContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class EstudanteRamImpl implements EstudanteContrato {
  static int _proximoId = 0;

  final Map<String, Estudante> _dados = {};

  @override
  Future<void> salvar(Estudante estudante) async {
    _proximoId++;

    final modelo = EstudanteModelo(
      id: _proximoId.toString(),
      tipo: avaliacao.tipo,
      estudante: avaliacao.estudante,
      estudanteId: avaliacao.estudanteId,
      data: avaliacao.data,
      disciplinaId: avaliacao.disciplinaId,
      nota: avaliacao.nota,
    );

    _dados[estudante.id] = estudante;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<Estudante>> listar(bool maisRecente) async {
    final lista = _dados.values.toList();

    if (maisRecente) {
      lista.sort((a, b) => b.id.compareTo(a.id));
      return lista;
    }

      lista.sort((a, b) => a.id.compareTo(b.id));
      return lista;

  }

  @override
  Future<Estudante?> buscarPorId(String id) async => _dados[id];
}
