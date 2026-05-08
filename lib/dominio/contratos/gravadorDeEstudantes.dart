
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

abstract interface class GravadorDeEstudantes {

  Future<bool> gravar(Estudante estudante) async{
    try{

      return true;
    }catch(e){

      return false;
    }
  }
}