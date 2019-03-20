FROM gradle:5.2.1-jdk11-slim as builder
COPY --chown=gradle:gradle . /home/spring-boot-jpa/
WORKDIR /home/spring-boot-jpa/
RUN gradle build

FROM openjdk:11.0.2-jre-slim-stretch
MAINTAINER GP <gpuliyar@gmail.com>
EXPOSE 8080
COPY --from=builder /home/spring-boot-jpa/build/libs/k8s.app-0.0.1.jar /app/sprint-boot-jpa.jar
WORKDIR /app
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "spring-boot-jpa.jar"]
