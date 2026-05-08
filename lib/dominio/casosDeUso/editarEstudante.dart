
import 'package:tp2_rui_elmer/dominio/contratos/encontradorDeEstudantes.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class EditarEstudante {

  EncontradorEstudantes _encontrador;

  EditarEstudante(this._encontrador);

  editar({required String estudanteId,
    String? nome,
    String? apelido,
    String? turma,
    String? curso}) {

    Estudante? estudante = _encontrador.encontrar(estudanteId);

    if(estudante == null) return;

    if (nome != null) estudante?.nome = nome;
    if (apelido != null) estudante?.apelido = apelido;
    if (turma != null) estudante?.turma = turma;
    if (curso != null) estudante?.curso = curso;
  }
}