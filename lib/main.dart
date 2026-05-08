import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'apresentacao/providers/gestao_notas_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GestaoNotasProvider.memoria()..carregarTudo(),
      child: const GestaoNotasApp(),
    ),
  );
}
