import 'package:tp2_rui_elmer/dataLayer/models/DisciplinaModelo.dart';
import 'package:tp2_rui_elmer/dominio/contratos/disciplinaContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';

class DisciplinaRamImpl implements DisciplinaContrato {
  static int _proximoId = 0;

  final Map<String, DisciplinaModelo> _dados = {};

  @override
  Future<void> salvar(Disciplina disciplina) async {
    String? id = disciplina.id;
    if (id == null || id.isEmpty || id == '-1') {
      _proximoId++;
      id = _proximoId.toString();
    }

    final modelo = DisciplinaModelo(
      id: id,
      nome: disciplina.nome,
      dataDeCriacao: disciplina.dataDeCriacao,
      curso: disciplina.curso,
      descricao: disciplina.descricao,
      alunosIniciais: disciplina.alunos,
    );

    _dados[id] = modelo;
    disciplina.id = id;
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
