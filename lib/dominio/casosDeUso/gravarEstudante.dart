
import 'package:tp2_rui_elmer/dominio/contratos/gravadorDeEstudantes.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';


class GravarEstudante {

  GravadorDeEstudantes _gravadorExterno;// já não é necessária persistência
  GravadorDeEstudantes _gravadorInterno;// array de estudantes na RAM

  GravarEstudante({required GravadorDeEstudantes gravadorExterno,
      required GravadorDeEstudantes gravadorInterno }):
    _gravadorExterno = gravadorExterno,
    _gravadorInterno = gravadorInterno
  {}


 void gravar(Estudante estudante) async{
    _gravadorExterno.gravar(estudante);
    _gravadorInterno.gravar(estudante);
  }

}
