# Slutprojekt – Terraform och PowerShell

**Kurs:** Infrastruktur konfigurering och deployment med programmering (ITINF25)
**GitHub:** <!-- TODO: klistra in länken till ditt repo här -->

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

Stå i projektmappen och kör:

```powershell
cd terraform
terraform init
terraform apply
cd ..
.\deploy.ps1
.\verify.ps1
```

Vill du ha prod i stället för dev:

```powershell
terraform apply -var "environment=prod"
```

Ta bort allt igen:

```powershell
cd terraform
terraform destroy
```

## 6. Verifiering

`verify.ps1` kollar att `config.json`, `deploy.log`, mapparna `Data` och `Backup` och `status.txt` finns, och att miljön är `dev` eller `prod`.

## 7. Reflektion

<!-- TODO: skriv detta själv, med egna ord -->

**Vad gick bra?**

**Vad var svårt?**
