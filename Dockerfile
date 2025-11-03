# Build stage: Use Maven image with JDK 25 included
FROM maven:4.0.0-eclipse-temurin-25 AS build

WORKDIR /app

# Copy pom.xml and download dependencies for caching
COPY pom.xml .

RUN mvn dependency:go-offline -B

# Copy source code and build the jar
COPY src ./src

RUN mvn clean package -DskipTests

# Run stage: Use slim JRE 25 image to run the application
FROM eclipse-temurin:25-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]

