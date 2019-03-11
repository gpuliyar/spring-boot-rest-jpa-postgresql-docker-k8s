FROM openjdk:11.0.2-jre-slim-stretch
MAINTAINER GP <gpuliyar@gmail.com>
EXPOSE 8080
ARG JAR_FILE=build/libs/k8s.app-0.0.1.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]
