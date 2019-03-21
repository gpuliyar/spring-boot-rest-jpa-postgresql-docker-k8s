FROM gradle:5.2.1-jdk11-slim as builder
COPY --chown=gradle:gradle . /home/spring-boot-jpa/
WORKDIR /home/spring-boot-jpa/
RUN gradle build
RUN /bin/ls -l

FROM openjdk:11.0.2-jre-slim-stretch
LABEL maintainer="GP"
EXPOSE 8080
COPY --from=builder /home/spring-boot-jpa/build/libs/k8s.app-0.0.1.jar /app/sprint-boot-jpa.jar
WORKDIR /app
RUN /bin/ls -l
RUN /bin/ls -l /app/
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "spring-boot-jpa.jar"]
