import '../contratos/disciplinaContrato.dart';

class RemoverDisciplina {

  final DisciplinaContrato _repositorio;

  RemoverDisciplina(this._repositorio);

  Future<void> executar(String id) async => await _repositorio.remover(id);
}