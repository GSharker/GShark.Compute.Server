#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["/src/GShark.Compute.Server.Api/GShark.Compute.Server.Api.csproj", "GShark.Compute.Server.Api/"]
RUN dotnet restore "GShark.Compute.Server.Api/GShark.Compute.Server.Api.csproj"
COPY . .
WORKDIR "/src/GShark.Compute.Server.Api"
RUN dotnet build "GShark.Compute.Server.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GShark.Compute.Server.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GShark.Compute.Server.Api.dll"]