# Use a Gradle image to build the JAR
FROM gradle:7.5.0-jdk11 AS builder

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Build the project
RUN gradle clean build

# Use a JDK image to run the application
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the builder stage
COPY --from=builder /app/build/libs/*.jar /app/app.jar

# Expose the port the app runs on
EXPOSE 8080

# Set environment variables for database connection
ENV MYSQL_HOST=mysql
ENV MYSQL_PORT=3306
ENV MYSQL_DB=test
ENV MYSQL_USER=root
ENV MYSQL_PASSWORD=root

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]