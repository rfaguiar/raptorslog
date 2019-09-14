#FROM gradle:jdk12 as builder
#COPY --chown=gradle:gradle . /home/src
#WORKDIR /home/src
#RUN gradle build

FROM openjdk:12
#COPY --from=builder /home/src/build/libs/*.jar /app.jar
COPY ./build/libs/*.jar  /app.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","/app.jar"]