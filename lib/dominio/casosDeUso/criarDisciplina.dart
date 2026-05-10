import '../contratos/disciplinaContrato.dart';
import '../entidades/disciplina.dart';

class CriarDisciplina {
  final DisciplinaContrato _repositorio;
  CriarDisciplina(this._repositorio);

  Future<Disciplina> executar({
    required String nome,
    required String curso,
    String? descricao,
  }) async {
    final disciplina = Disciplina(
      nome: nome,
      curso: curso,
      descricao: descricao ?? '',
      dataDeCriacao: DateTime.now(),
    );
    await _repositorio.salvar(disciplina);
    return disciplina;
  }
}
