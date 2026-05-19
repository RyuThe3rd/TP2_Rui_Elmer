import '../contratos/disciplinaContrato.dart';

class EditarDisciplina {
  final DisciplinaContrato _repositorio;

  EditarDisciplina(this._repositorio);

  Future<void> executar({
    required String id,
    String? nome,
    String? curso,
    String? descricao,
  }) async {
    final disciplina = await _repositorio.buscarPorId(id);
    if (disciplina == null) return;

    if (nome != null) disciplina.nome = nome;
    if (curso != null) disciplina.curso = curso;
    if (descricao != null) disciplina.descricao = descricao;

    await _repositorio.salvar(disciplina);
  }
}
