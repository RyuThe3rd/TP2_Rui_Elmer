
import 'gravarEstudante.dart';
import 'package:tp2_rui_elmer/dominio/entidades/estudante.dart';

class CriarEstudante {

  final GravarEstudante _gravador;
  CriarEstudante(this._gravador);


  Estudante executar({required String nome,
    required String apelido,
    required String turma,
    required String curso}){

    DateTime dataDeInscricao = DateTime.now();
    final estudante = Estudante(nome: nome, apelido: apelido, dataDeInscricao: dataDeInscricao, turma: turma, curso: curso);

    //do tipo criarEstudante --<<includes>>--> gravarEstudante
    _gravador.gravar(estudante);

    return estudante;
  }


}