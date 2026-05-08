
import 'package:tp2_rui_elmer/dominio/contratos/baseDeDadosEstudantes.dart';
import 'package:tp2_rui_elmer/dominio/contratos/encontradorDeEstudantes.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class EncontradorRepoImpl implements EncontradorEstudantes{
  @override
  BdEstudante bdEstudantes;

  EncontradorRepoImpl(this.bdEstudantes);

  @override
  Estudante? encontrar(String estudanteId) {
    // TODO: implement encontrar
    throw UnimplementedError();
  }



}