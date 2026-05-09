
import 'package:tp2_rui_elmer/dominio/contratos/disciplinaContrato.dart';
import 'package:tp2_rui_elmer/dominio/contratos/estudanteContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/disciplina.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class InscreverEstudanteEmDisciplina {

  DisciplinaContrato _disciplinaRepo;
  EstudanteContrato _estudanteRepo;

  InscreverEstudanteEmDisciplina(this._estudanteRepo,
      this._disciplinaRepo){


  }

  Future<void> inscrever(estudanteId, disciplinaId) async{

    final estudante = await _estudanteRepo.buscarPorId(estudanteId);
    final disciplina = await _disciplinaRepo.buscarPorId(disciplinaId);

    if (estudante == null || disciplina == null) {
      throw Exception("Não foi possível realizar a inscrição: dados inválidos.");
    }

    disciplina.alunos.add(estudante);

    await _disciplinaRepo.salvar(disciplina);

    print("Sucesso: Estudante ${estudante.nome} inscrito em ${disciplina.nome}");
  }
}