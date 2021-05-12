FROM adoptopenjdk:11-jre-hotspot
COPY target/filtch-0.0.1-SNAPSHOT.jar filtch.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/filtch.jar"]
