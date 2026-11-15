# deploy.ps1
# Läser config.json från Terraform och konfigurerar projektet.
# Kör från projektmappen:  .\deploy.ps1

# Funktion som skriver ett meddelande på skärmen och i loggfilen
function Write-Log($message) {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$time - $message"
    Write-Host $line
    Add-Content -Path ".\projekt\Logs\deploy.log" -Value $line
}

try {
    # 1. Läs config.json som Terraform skapade
    $config = Get-Content ".\projekt\Config\config.json" -ErrorAction Stop | ConvertFrom-Json
    Write-Log "Startar deploy för $($config.project_name)"

    # 2. Skapa mappar med en loop
    $folders = @("Data", "Backup")

    foreach ($folder in $folders) {
        $path = ".\projekt\$folder"

        if (Test-Path $path) {
            Write-Log "Mappen $folder finns redan"
        }
        else {
            New-Item -Path $path -ItemType Directory | Out-Null
            Write-Log "Skapade mappen $folder"
        }
    }

    # 3. Olika inställning beroende på miljö
    if ($config.environment -eq "prod") {
        $backupDays = 30
    }
    else {
        $backupDays = 7
    }
    Write-Log "Miljö: $($config.environment), backup sparas i $backupDays dagar"

    # 4. Skriv en statusfil som visar att deploy är klar
    Set-Content -Path ".\projekt\Data\status.txt" -Value "Deploy klar ($($config.environment))"
    Write-Log "Deploy klar!"
}
catch {
    Write-Host "FEL: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Har du kört 'terraform apply' först?" -ForegroundColor Red
}
