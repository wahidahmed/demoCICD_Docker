# Stage 1 - build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy csproj(s) first to leverage Docker layer cache
COPY ["demoCICD_Docker.csproj", "./"]
RUN dotnet restore "./demoCICD_Docker.csproj"

# copy everything else and publish
COPY . .
RUN dotnet publish "demoCICD_Docker.csproj" -c Release -o /app/publish

# Stage 2 - runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:80
EXPOSE 80
ENTRYPOINT ["dotnet", "demoCICD_Docker.dll"]
