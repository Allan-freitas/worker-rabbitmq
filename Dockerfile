FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine AS build-env
WORKDIR /app

# Copiar csproj e restaurar dependencias
COPY /Worker/ ./
RUN dotnet restore

RUN pwsh -Command Write-Host "NetCore: Gerando uma nova imagem Docker e testando o PowerShell Core"

# Build da aplicacao
COPY . ./
RUN dotnet publish -c Release -o out

# Build da imagem
FROM mcr.microsoft.com/dotnet/aspnet:5.0-buster-slim
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "WorkerRabbitMq.dll"]