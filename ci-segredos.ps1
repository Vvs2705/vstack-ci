# Envia UNITY_LICENSE, UNITY_EMAIL e UNITY_PASSWORD (o mesmo valor) para varios repositorios, via gh.
# Nada e gravado no PC: o e-mail e a senha ficam so na memoria deste processo e vao ao GitHub por stdin.
param([string[]]$Repos)
$ErrorActionPreference = 'Stop'
$padrao = @('tiny-airport-empire','dungeon-courier','chronicles-of-existence','arkana','forge-street','rune-relay',
            'mystic-kitchen','underground-inc','scrapstorm','beast-haven','skyhold-cargo')
if (-not $Repos -or $Repos.Count -eq 0) { $Repos = $padrao }
$dono = 'Vvs2705'
$ulf = 'C:\ProgramData\Unity\Unity_lic.ulf'

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { Write-Host 'Falta o GitHub CLI (gh). Instale e rode gh auth login.'; exit 1 }
if (-not (Test-Path $ulf)) {
  Write-Host "Nao achei $ulf."
  Write-Host 'No Unity Hub: engrenagem > Licencas > Adicionar > Obter licenca Personal gratuita. Depois rode de novo.'
  exit 1
}

$email = Read-Host 'E-mail da conta Unity'
$senhaSegura = Read-Host 'Senha da conta Unity (nao aparece)' -AsSecureString
$senha = [System.Net.NetworkCredential]::new('', $senhaSegura).Password
$licenca = Get-Content -Raw $ulf

$falhas = @()
foreach ($r in $Repos) {
  $alvo = "$dono/$r"
  Write-Host "== $alvo"
  try {
    $licenca | gh secret set UNITY_LICENSE -R $alvo
    $email   | gh secret set UNITY_EMAIL   -R $alvo
    $senha   | gh secret set UNITY_PASSWORD -R $alvo
    if ($LASTEXITCODE -ne 0) { throw 'gh falhou' }
  } catch { $falhas += $alvo; Write-Host "   falhou: $alvo" }
}
$senha = $null; $email = $null; $licenca = $null
Write-Host ''
if ($falhas.Count -eq 0) { Write-Host 'Pronto: segredos cadastrados em todos os repositorios.' }
else { Write-Host ('Falharam: ' + ($falhas -join ', ') + '. Tire um print e mande para o Claude.') }
