import '../contratos/estudanteContrato.dart';
import '../entidades/estudante.dart';

class EditarEstudante {
  final EstudanteContrato _repositorio;

  EditarEstudante(this._repositorio);

  Future<void> executar({
    required String estudanteId,
    String? nome,
    String? apelido,
    String? turma,
    String? curso,
  }) async {
    final estudante = await _repositorio.buscarPorId(estudanteId);

    if (estudante == null) return;

    if (nome != null) estudante.nome = nome;
    if (apelido != null) estudante.apelido = apelido;
    if (turma != null) estudante.turma = turma;
    if (curso != null) estudante.curso = curso;

    await _repositorio.salvar(estudante);
  }
}
