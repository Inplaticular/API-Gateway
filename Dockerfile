# 1. Build application in image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

WORKDIR /src

COPY ["Src/ApiGateway/ApiGateway.csproj", "ApiGateway/"]

RUN dotnet restore "ApiGateway/ApiGateway.csproj"

COPY ./Src .
WORKDIR "/src/ApiGateway"

RUN dotnet build "ApiGateway.csproj" -c Release -o /app/build

# 2. Publish built application in image
FROM build AS publish
RUN dotnet publish "ApiGateway.csproj" -c Release -o /app/publish

# 3. Take published version
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS final
EXPOSE 80
WORKDIR /app
COPY --from=publish /app/publish .