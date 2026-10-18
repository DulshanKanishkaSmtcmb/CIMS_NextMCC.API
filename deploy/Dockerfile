# Build from the repository root:  docker build -f deploy/Dockerfile -t cims-nextmcc-api .
# Mirrors CIMS.Cargo.API (Windows nanoserver images, because the CIMS hosts run Windows containers); .NET 10.

FROM mcr.microsoft.com/dotnet/aspnet:10.0-nanoserver-ltsc2022 AS base
WORKDIR /app
EXPOSE 8080

FROM mcr.microsoft.com/dotnet/sdk:10.0-nanoserver-ltsc2022 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
# Restore first (layer cache): central package management needs the two props files next to the projects.
COPY ["Directory.Build.props", "Directory.Packages.props", "./"]
COPY ["src/CIMSNextMCC.API/CIMSNextMCC.API.csproj", "src/CIMSNextMCC.API/"]
COPY ["src/CIMSNextMCC.Application/CIMSNextMCC.Application.csproj", "src/CIMSNextMCC.Application/"]
COPY ["src/CIMSNextMCC.Domain/CIMSNextMCC.Domain.csproj", "src/CIMSNextMCC.Domain/"]
COPY ["src/CIMSNextMCC.Infrastructure/CIMSNextMCC.Infrastructure.csproj", "src/CIMSNextMCC.Infrastructure/"]
RUN dotnet restore "src/CIMSNextMCC.API/CIMSNextMCC.API.csproj"
COPY src/ src/
WORKDIR "/src/src/CIMSNextMCC.API"
RUN dotnet build "CIMSNextMCC.API.csproj" -c $BUILD_CONFIGURATION -o /app/build --no-restore

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "CIMSNextMCC.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish --no-restore /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CIMSNextMCC.API.dll"]
