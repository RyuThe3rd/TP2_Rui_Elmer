import '../contratos/estudanteContrato.dart';

class RemoverEstudante {
  final EstudanteContrato _repositorio;
  RemoverEstudante(this._repositorio);

  Future<void> executar(String id) async => await _repositorio.remover(id);
}