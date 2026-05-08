import 'package:tp2_rui_elmer/dominio/contratos/baseDeDadosEstudantes.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

abstract interface class EncontradorEstudantes {

  BdEstudante bdEstudantes;

  EncontradorEstudantes(this.bdEstudantes);

  Estudante? encontrar(String estudanteId){

    return null;
  }

}