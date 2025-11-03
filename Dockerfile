# Use Maven with JDK 25 for building the app
FROM eclipse-temurin:25-jdk AS build

# Set working directory inside the container
WORKDIR /app

# Copy pom.xml and download dependencies first (for caching)
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml is unchanged)
RUN mvn dependency:go-offline -B

# Copy the source code to the container
COPY src ./src

# Build the Spring Boot app and package it into a jar
RUN mvn clean package -DskipTests

# Use a smaller JRE image for running the app
FROM eclipse-temurin:25-jre

# Set working directory inside the container
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port your Spring Boot app runs on (default 8080)
EXPOSE 8080

# Run the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
