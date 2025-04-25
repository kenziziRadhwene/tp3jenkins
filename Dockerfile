FROM eclipse-temurin:17-jdk-jammy  # JDK 17 recommandé pour Spring Boot 2.7+

# Paramètres de build
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

# Configuration sécurité
RUN addgroup --system spring && adduser --system spring --ingroup spring
USER spring:spring

# Paramètres d'exécution
ENTRYPOINT ["java","-jar","/app.jar"]
CMD ["--spring.profiles.active=prod"]  # Séparation ENTRYPOINT/CMD pour plus de flexibilité
