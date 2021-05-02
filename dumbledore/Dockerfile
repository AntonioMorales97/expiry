FROM adoptopenjdk:11-jre-hotspot
COPY target/dumbledore-0.0.1-SNAPSHOT.jar dumbledore.jar
ENV PORT 8080
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/dumbledore.jar"]