# Estrutura de Pastas - lib

Abaixo está a estrutura de pastas e arquivos do diretório `lib` do projeto:

```text
lib/
├── dataLayer/
│   ├── models/
│   │   ├── AvaliacaoModelo.dart
│   │   ├── DisciplinaModelo.dart
│   │   └── EstudanteModelo.dart
│   ├── repositorios/
│   │   ├── avaliacao_ram_repositorio.dart
│   │   ├── disciplina_ram_repositorio.dart
│   │   └── estudante_ram_repository.dart
│   └── services/ (vazio)
├── dominio/
│   ├── casosDeUso/
│   │   ├── calcularMediaPorDisciplina.dart
│   │   ├── consultarNotaPorDisciplina.dart
│   │   ├── criarAvaliacao.dart
│   │   ├── criarDisciplina.dart
│   │   ├── criarEstudante.dart
│   │   ├── editarDisciplina.dart
│   │   ├── editarEstudante.dart
│   │   ├── gravarEstudante.dart
│   │   └── inscreverEstudante.dart
│   ├── contratos/
│   │   ├── avaliacaoContrato.dart
│   │   ├── disciplinaContrato.dart
│   │   ├── estudanteContrato.dart
│   │   ├── gravadorDeEstudantes.dart
│   │   └── inscricao_repository.dart
│   └── entidades/
│       ├── avaliacao.dart
│       ├── disciplina.dart
│       ├── enums.dart
│       ├── estudante.dart
│       ├── inscricao.dart
│       └── nota.dart
├── presentationLayer/
│   ├── paginas/
│   │   ├── avaliacoes_page.dart
│   │   ├── disciplinas_page.dart
│   │   ├── estudantes_page.dart
│   │   ├── home_page.dart
│   │   ├── inscricoes_page.dart
│   │   └── notas_page.dart
│   └── providers/ (vazio)
└── main.dart
```
