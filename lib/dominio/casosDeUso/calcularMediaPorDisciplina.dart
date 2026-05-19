
import 'package:tp2_rui_elmer/dominio/contratos/avaliacaoContrato.dart';
import 'package:tp2_rui_elmer/dominio/contratos/disciplinaContrato.dart';

class CalcularMediaPorDisciplina {

  AvaliacaoContrato avaliacaoContrato;

  //provavelmente algo do tipo avaliacaoContrato : argumentoRepo,
  CalcularMediaPorDisciplina({
    required this.avaliacaoContrato});

  //this one was pretty easy
  Future<double> calcularMedia({required String disciplinaId}) async {

    final avaliacoes = await avaliacaoContrato.listarPorDisciplina(disciplinaId);

    double notas = 0;
    for(var temp in avaliacoes) {
      notas += temp.nota;

    }

    double media = notas / avaliacoes.length;

    return media;

  }
}