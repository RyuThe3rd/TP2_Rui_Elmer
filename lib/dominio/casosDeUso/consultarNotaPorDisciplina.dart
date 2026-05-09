
import 'package:tp2_rui_elmer/dominio/contratos/avaliacaoContrato.dart';
import 'package:tp2_rui_elmer/dominio/contratos/disciplinaContrato.dart';
import 'package:tp2_rui_elmer/dominio/contratos/estudanteContrato.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class ConsultarNotaPorDisciplina {

  EstudanteContrato estudanteContrato;
  DisciplinaContrato disciplinaContrato;
  AvaliacaoContrato avaliacaoContrato;

  ConsultarNotaPorDisciplina({required this.estudanteContrato,
    required this.disciplinaContrato,
    required this.avaliacaoContrato});

  //Nota da avaliação por estudante e Disciplina
  Future<List<Map<String, dynamic>>> consultarNotasDaDisciplina({required String disciplinaId}) async {

    final disciplina = await disciplinaContrato.buscarPorId(disciplinaId);
    final avaliacoes = await avaliacaoContrato.listarPorDisciplina(disciplinaId);

    final listaNotas = avaliacoes.map((avaliacao) async {
      Estudante? estudante = await estudanteContrato.buscarPorId(avaliacao.estudanteId);

      return{
        'estudante': estudante?.nome ?? '-1',
        'disciplina': disciplina?.nome ?? '-1',
        'avaliacao': avaliacao.tipo.name,
        'nota': avaliacao.nota
      };
    }
      ).toList();

    return await Future.wait(listaNotas);

    }
}
