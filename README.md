# Slutprojekt – Terraform och PowerShell

**Kurs:** Infrastruktur konfigurering och deployment med programmering (ITINF25)

**GitHub:** https://github.com/Mus1o/IaC-projekt

## 1. Mål

Automatisera uppsättningen av ett litet projekt med kod i stället för att göra det för hand.

## 2. Hur kedjan fungerar

```
Terraform  ->  deploy.ps1  ->  verify.ps1
skapar         konfigurerar    kontrollerar
```

1. **Terraform** skapar `config.json` och en loggfil.
2. **deploy.ps1** läser `config.json`, skapar mapparna `Data` och `Backup` och skriver i loggen.
3. **verify.ps1** kontrollerar att allt finns.

Terraform och PowerShell hänger ihop genom `config.json`.

## 3. Filer

| Fil | Vad den gör |
|---|---|
| `terraform/main.tf` | Två resurser: `config.json` och `deploy.log` |
| `terraform/variables.tf` | Variablerna `project_name` och `environment` |
| `terraform/outputs.tf` | Visar resultatet efter `terraform apply` |
| `deploy.ps1` | Konfigurerar projektet |
| `verify.ps1` | Kontrollerar resultatet |

## 4. Installation

- Windows med PowerShell
- Terraform: `winget install Hashicorp.Terraform`
- Git

## 5. Så kör du

Stå i projektmappen och kör.

Windows blockerar `.ps1`-skript som standard. Tillåt dem först, bara för det här PowerShell-fönstret:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Kör sedan kedjan:

```powershell
cd terraform
terraform init
terraform apply
cd ..
.\deploy.ps1
.\verify.ps1
```

Vill du ha prod i stället för dev (kör deploy och verify igen efteråt):

```powershell
cd terraform
terraform apply -var "environment=prod"
cd ..
.\deploy.ps1
.\verify.ps1
```

Ta bort det Terraform har skapat:

```powershell
cd terraform
terraform destroy
cd ..
```

`destroy` tar bara bort filer som Terraform fortfarande har i sin state. `config.json` tas bort. `deploy.log` ligger kvar om `deploy.ps1` har skrivit i den, eftersom Terraform då ser att innehållet har ändrats och släpper filen ur sin state. Mapparna `Data` och `Backup` skapades av PowerShell, så de tas inte heller bort av Terraform. Ta bort hela resultatet med:

```powershell
Remove-Item -Recurse -Force .\projekt
```

## 6. Verifiering

`verify.ps1` kollar att `config.json`, `deploy.log`, mapparna `Data` och `Backup` och `status.txt` finns, och att miljön är `dev` eller `prod`.

## 7. Reflektion

**Vad gick bra?**

Jag tyckte att Terraform var lättare än jag trodde. Det var bra att `terraform plan` visade exakt vad som skulle skapas innan något hände, så jag kunde kontrollera att det stämde.

**Vad var svårt?**

Det var svårt att förstå varför try/catch inte fångade fel ibland. Jag lärde mig att man måste skriva `-ErrorAction Stop`, annars hoppar PowerShell inte till catch.
