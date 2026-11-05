# vstack-ci

Workflow reutilizável de Unity (GameCI) para os jogos da V-STACK. Sem código de jogo, arte ou segredo.

## Como um jogo usa

Crie `.github/workflows/unity.yml` no jogo:

```yaml
name: unity
on:
  pull_request:
    paths: ['client/**', '.github/workflows/unity.yml']
  push:
    branches: [main]
    paths: ['client/**', '.github/workflows/unity.yml']
  workflow_dispatch:
permissions:
  contents: read
  checks: write
jobs:
  unity:
    uses: Vvs2705/vstack-ci/.github/workflows/unity.yml@main
    with:
      project-path: client          # arkana: mobile-unity
      unity-version: 6000.3.23f1    # a mesma de ProjectVersion.txt
    secrets:
      UNITY_LICENSE: ${{ secrets.UNITY_LICENSE }}
      UNITY_EMAIL: ${{ secrets.UNITY_EMAIL }}
      UNITY_PASSWORD: ${{ secrets.UNITY_PASSWORD }}
```

## Entradas

| Entrada | Padrão | O que faz |
|---|---|---|
| `project-path` | `client` | Pasta do projeto Unity (onde fica `ProjectSettings`) |
| `unity-version` | `6000.3.27f1` | Versão do editor (a de `ProjectVersion.txt`) |
| `build-android` | `true` | Faz o build Android |
| `build-windows` | `true` | Faz o build Windows |
| `build-method-android` | vazio | Método estático de build (ex.: `TA.EditorTools.Setup.BuildAndroidDev`); vazio usa o build padrão do GameCI |
| `build-method-windows` | vazio | Idem para Windows |

## O que acontece sozinho

- Sem os segredos `UNITY_LICENSE`, `UNITY_EMAIL` e `UNITY_PASSWORD`, os jobs de Unity são pulados com um aviso (não ficam vermelhos).
- Sem `ProjectSettings/ProjectVersion.txt` em `project-path` (jogo que ainda não começou), idem: pula com aviso.
- Jogos que ainda usam a versão 6000.3.23f1 e os que usam 6000.3.27f1 passam a versão como entrada.

## Segredos

São por repositório (conta pessoal não tem segredo global). Quem põe é o Vinicius, pelo script `ci-segredos.cmd` (aceita vários repositórios).
