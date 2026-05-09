import 'package:tp2_rui_elmer/dataLayer/models/AvaliacaoModelo.dart';
import 'package:tp2_rui_elmer/dominio/contratos/avaliacaoContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/avaliacao.dart';


class AvaliacaoRamImpl implements AvaliacaoContrato {
  static int _proximoId = 0;

  final Map<String,AvaliacaoModelo> _dados = {};

  @override
  Future<void> salvar(Avaliacao avaliacao) async {
    _proximoId++;

    final modelo = AvaliacaoModelo(
      id: _proximoId.toString(),
      tipo: avaliacao.tipo,
      estudante: avaliacao.estudante,
      estudanteId: avaliacao.estudanteId,
      data: avaliacao.data,
      disciplinaId: avaliacao.disciplinaId,
      nota: avaliacao.nota,
    );

    _dados[modelo.id] = modelo;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<AvaliacaoModelo>> listar() async {
    final lista = _dados.values.toList();
    lista.sort((a, b) => a.titulo.compareTo(b.titulo));
    return lista;
  }

  @override
  Future<List<AvaliacaoModelo>> listarPorDisciplina(String disciplinaId) async {
    return _dados.values.where((a) => a.disciplinaId == disciplinaId).toList();
  }

  @override
  Future<AvaliacaoModelo?> buscarPorId(String id) async => _dados[id];
}
