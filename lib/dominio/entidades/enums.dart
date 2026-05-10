enum Avaliacoes {
  mt1(0.1, 'Mini-teste 1'),
  mt2(0.1, 'Mini-teste 2'),
  teste1(0.4, 'Teste 1'),
  teste2(0.4, 'Teste 2'),
  exame(1.0, 'Exame'),
  recorrencia(1.0, 'Recorrência');

  final double peso;
  final String label;
  const Avaliacoes(this.peso, this.label);
}

enum Curso {
  LECC,
  LEIT,
  OUTROS
}
