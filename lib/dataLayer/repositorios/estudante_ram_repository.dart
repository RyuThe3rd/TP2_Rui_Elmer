import 'package:tp2_rui_elmer/dataLayer/models/EstudanteModelo.dart';
import 'package:tp2_rui_elmer/dominio/contratos/estudanteContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class EstudanteRamImpl implements EstudanteContrato {
  static int _proximoId = 0;

  final Map<String, EstudanteModelo> _dados = {};

  @override
  Future<void> salvar(Estudante estudante) async {
    _proximoId++;

    final modelo = EstudanteModelo(
      id: _proximoId.toString(),
      nome: estudante.nome,
      dataDeInscricao: estudante.dataDeInscricao,
      turma: estudante.turma,
      apelido: estudante.apelido,
      curso: estudante.curso,
    );

    _dados[modelo.id] =modelo;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<EstudanteModelo>> listar(bool maisRecente) async {
    final lista = _dados.values.toList();

    if (maisRecente) {
      lista.sort((a, b) => b.id.compareTo(a.id));
      return lista;
    }

      lista.sort((a, b) => a.id.compareTo(b.id));
      return lista;

  }

  @override
  Future<EstudanteModelo?> buscarPorId(String id) async => _dados[id];
}
