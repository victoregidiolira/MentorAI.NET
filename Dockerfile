# Estágio de Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia o arquivo de projeto e restaura as dependências
# AJUSTE AQUI SE O NOME DA PASTA FOR DIFERENTE
COPY ["MentorAI.API/MentorAI.API.csproj", "MentorAI.API/"]
RUN dotnet restore "MentorAI.API/MentorAI.API.csproj"

# Copia todo o código fonte e compila
COPY . .
WORKDIR "/src/MentorAI.API"
RUN dotnet build "MentorAI.API.csproj" -c Release -o /app/build

# Publica a aplicação
FROM build AS publish
RUN dotnet publish "MentorAI.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Estágio Final (Runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Define a porta 8080 (padrão do .NET 8)
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "MentorAI.API.dll"]
