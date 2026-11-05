@echo off
rem Cadastra os segredos do CI do Unity em varios repositorios de uma vez. De dois cliques e responda o que for pedido.
rem Uso opcional: ci-segredos.cmd repo1 repo2 ...  (sem argumentos usa a lista padrao dentro de ci-segredos.ps1)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0ci-segredos.ps1" %*
pause
