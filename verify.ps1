# verify.ps1
# Kontrollerar att Terraform och deploy.ps1 har fungerat.
# Kör från projektmappen:  .\verify.ps1

# Funktion som kollar om en fil eller mapp finns
function Test-Thing($path) {
    if (Test-Path $path) {
        Write-Host "OK      $path" -ForegroundColor Green
        return $true
    }
    else {
        Write-Host "SAKNAS  $path" -ForegroundColor Red
        return $false
    }
}

Write-Host "=== Verifiering ==="

# Allt som ska finnas när kedjan har körts
$things = @(
    ".\projekt\Config\config.json",
    ".\projekt\Logs\deploy.log",
    ".\projekt\Data",
    ".\projekt\Backup",
    ".\projekt\Data\status.txt"
)

$errors = 0

# Loop: kolla varje sak i listan
foreach ($thing in $things) {
    if (-not (Test-Thing $thing)) {
        $errors++
    }
}

# Kolla att config.json innehåller en giltig miljö
try {
    $config = Get-Content ".\projekt\Config\config.json" -ErrorAction Stop | ConvertFrom-Json

    if ($config.environment -eq "dev" -or $config.environment -eq "prod") {
        Write-Host "OK      Miljön är $($config.environment)" -ForegroundColor Green
    }
    else {
        Write-Host "FEL     Okänd miljö: $($config.environment)" -ForegroundColor Red
        $errors++
    }
}
catch {
    Write-Host "FEL     Kunde inte läsa config.json" -ForegroundColor Red
    $errors++
}

# Resultat
if ($errors -eq 0) {
    Write-Host "Allt fungerar!" -ForegroundColor Green
}
else {
    Write-Host "$errors fel hittades" -ForegroundColor Red
}
