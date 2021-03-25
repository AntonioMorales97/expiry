FROM adoptopenjdk:11-jre-hotspot
COPY target/dumbledore-0.0.1-SNAPSHOT.jar dumbledore.jar
EXPOSE 9090
ENTRYPOINT ["java", "-jar", "/dumbledore.jar"]