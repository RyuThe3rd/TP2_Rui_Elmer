import 'package:tp2_rui_elmer/dominio/contratos/disciplinaContrato.dart';
import 'package:tp2_rui_elmer/dataLayer/models/DisciplinaModelo.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';

class DisciplinaRamImpl implements DisciplinaContrato {
  static int _proximoId = 0;

  final Map<String, DisciplinaModelo> _dados = {};

  @override
  Future<void> salvar(Disciplina disciplina) async {
    _proximoId++;

    final modelo = DisciplinaModelo(
      id: _proximoId.toString(),
      nome: disciplina.nome,
      dataDeCriacao: disciplina.dataDeCriacao,
      curso: disciplina.curso,
      descricao: disciplina.descricao,
    );


    _dados[modelo.id] = modelo;
  }

  @override
  Future<void> remover(String id) async {
    _dados.remove(id);
  }

  @override
  Future<List<DisciplinaModelo>> listar() async {
    final lista = _dados.values.toList();
    lista.sort((a, b) => a.nome.compareTo(b.nome));
    return lista;
  }

  @override
  Future<DisciplinaModelo?> buscarPorId(String id) async => _dados[id];
}
