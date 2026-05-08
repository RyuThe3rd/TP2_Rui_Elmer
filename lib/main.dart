//import 'package:flutter/material.dart';

// 1. Declarar fora do main (Escopo Global do ficheiro)
enum Avaliacao {
  ac, // Usar letras minúsculas é a convenção (camelCase)
  as,
  ap
}

void main() {
  // 2. O acesso ao .values e .name está correto para versões Dart 2.17+
  for (var nota in Avaliacao.values) {
    print("Tipo de avaliação: ${nota.name}");
  }
}