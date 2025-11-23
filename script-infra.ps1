# --- CONFIGURAÇÕES ---
$PREFIX = "mentorai-556653" 

$RG_NAME = "rg-$PREFIX"
$LOCATION = "eastus"
$ACR_NAME = ("acr" + $PREFIX).Replace("-", "").ToLower()
$PLAN_NAME = "plan-$PREFIX"
$WEBAPP_NAME = "app-$PREFIX"
$DB_NAME = "db-$PREFIX"
$DB_PASSWORD = "OraclePassword123!" 

Write-Host "--- 1. Criando Resource Group ---" -ForegroundColor Cyan
az group create --name $RG_NAME --location $LOCATION

Write-Host "--- 2. Criando Container Registry (ACR: $ACR_NAME) ---" -ForegroundColor Cyan
az acr create --resource-group $RG_NAME --name $ACR_NAME --sku Basic --admin-enabled true

Write-Host "--- 3. Criando Banco Oracle (Container ACI) ---" -ForegroundColor Cyan
# Cria o container do Oracle
az container create --resource-group $RG_NAME --name $DB_NAME --image gvenzl/oracle-free:slim --ports 1521 --environment-variables ORACLE_PASSWORD=$DB_PASSWORD --dns-name-label $DB_NAME --memory 2 --cpu 1 --os-type Linux

Write-Host "--- 4. Criando App Service Plan (Linux) ---" -ForegroundColor Cyan
az appservice plan create --name $PLAN_NAME --resource-group $RG_NAME --sku B1 --is-linux

Write-Host "--- 5. Criando Web App ---" -ForegroundColor Cyan
az webapp create --resource-group $RG_NAME --plan $PLAN_NAME --name $WEBAPP_NAME --deployment-container-image-name "mcr.microsoft.com/appsvc/staticsite:latest"

Write-Host "--- 6. Configurando Conexão ---" -ForegroundColor Cyan
$DB_HOST = "$DB_NAME.$LOCATION.azurecontainer.io"
$CONN_STRING = "Data Source=$DB_HOST:1521/FREEPDB1;User Id=system;Password=$DB_PASSWORD;"

# Configura a porta 8080 (necessária para .NET 8)
az webapp config appsettings set --resource-group $RG_NAME --name $WEBAPP_NAME --settings WEBSITES_PORT=8080
# Configura a string de conexão como variável de ambiente
az webapp config connection-string set --resource-group $RG_NAME --name $WEBAPP_NAME --settings ORACLE_CONN="$CONN_STRING" --connection-string-type Custom

Write-Host "--- SUCESSO! ---" -ForegroundColor Green
Write-Host "ANOTE ESTES DADOS PARA CONFIGURAR O PIPELINE E O BANCO:" -ForegroundColor Yellow
Write-Host "ACR Name: $ACR_NAME"
Write-Host "Web App Name: $WEBAPP_NAME"
Write-Host "Host do Banco (Use no DBeaver): $DB_HOST"
Write-Host "Service Name: FREEPDB1"
Write-Host "User: system"
Write-Host "Password: $DB_PASSWORD"