# Vi använder "local"-providern. Den skapar filer på den egna datorn.
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

# Resurs 1: config.json som PowerShell ska läsa
resource "local_file" "config" {
  filename = "../projekt/Config/config.json"
  content = jsonencode({
    project_name = var.project_name
    environment  = var.environment
  })
}

# Resurs 2: en loggfil som PowerShell skriver vidare i
resource "local_file" "log" {
  filename = "../projekt/Logs/deploy.log"
  content  = "Loggfil skapad av Terraform\n"
}
