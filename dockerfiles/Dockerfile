FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["MentorAI.API/MentorAI.API.csproj", "MentorAI.API/"]
RUN dotnet restore "MentorAI.API/MentorAI.API.csproj"
COPY . .
WORKDIR "/src/MentorAI.API"
RUN dotnet build "MentorAI.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MentorAI.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "MentorAI.API.dll"]
