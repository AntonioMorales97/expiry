FROM adoptopenjdk:11-jre-hotspot
COPY target/hagrid-0.0.1-SNAPSHOT.jar hagrid.jar
EXPOSE 9090
ENTRYPOINT ["java", "-jar", "/hagrid.jar"]