
void main() {
  //clean architecture pura não me parece ser tão prático

  // Repositorios (Data Layer usando Models internamente)
  final estudanteRepo = EstudanteRamImpl();
  final disciplinaRepo = DisciplinaRamImpl();
  final avaliacaoRepo = AvaliacaoRamImpl();

  // Casos de Uso (Domínio)
  final gestorNotas = GestorNotas(avaliacaoRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GestaoEscolarProvider(
            estudanteRepo: estudanteRepo,
            disciplinaRepo: disciplinaRepo,
            avaliacaoRepo: avaliacaoRepo,
            gestorNotas: gestorNotas,
          ),
        ),
      ],
      child: const GestaoEscolarApp(),
    ),
  );
}