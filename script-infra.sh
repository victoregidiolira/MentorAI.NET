#!/bin/bash
# Mude 'SEURM' para o seu RM real para garantir que o nome seja único
PREFIX="mentorai-556653" 
RG_NAME="rg-$PREFIX"
LOCATION="eastus"
ACR_NAME="acr$PREFIX"
PLAN_NAME="plan-$PREFIX"
WEBAPP_NAME="app-$PREFIX"
DB_NAME="db-$PREFIX"
DB_PASSWORD="OraclePassword123!" 

echo "--- 1. Criando Resource Group ---"
az group create --name $RG_NAME --location $LOCATION

echo "--- 2. Criando Container Registry (ACR) ---"
az acr create --resource-group $RG_NAME --name $ACR_NAME --sku Basic --admin-enabled true

echo "--- 3. Criando Banco Oracle (Container) ---"
az container create --resource-group $RG_NAME --name $DB_NAME --image gvenzl/oracle-free:slim --ports 1521 --environment-variables ORACLE_PASSWORD=$DB_PASSWORD --dns-name-label $DB_NAME --memory 2 --cpu 1

echo "--- 4. Criando App Service Plan (Linux) ---"
az appservice plan create --name $PLAN_NAME --resource-group $RG_NAME --sku B1 --is-linux

echo "--- 5. Criando Web App ---"
az webapp create --resource-group $RG_NAME --plan $PLAN_NAME --name $WEBAPP_NAME --deployment-container-image-name "mcr.microsoft.com/appsvc/staticsite:latest"

echo "--- 6. Configurando Conexão ---"
DB_HOST="$DB_NAME.$LOCATION.azurecontainer.io"
CONN_STRING="Data Source=$DB_HOST:1521/FREEPDB1;User Id=system;Password=$DB_PASSWORD;"

az webapp config appsettings set --resource-group $RG_NAME --name $WEBAPP_NAME --settings WEBSITES_PORT=8080
az webapp config connection-string set --resource-group $RG_NAME --name $WEBAPP_NAME --settings ORACLE_CONN="$CONN_STRING" --connection-string-type Custom

echo "--- DADOS FINAIS (ANOTE ISSO) ---"
echo "ACR Name: $ACR_NAME"
echo "Web App Name: $WEBAPP_NAME"
echo "Host do Banco: $DB_HOST"
