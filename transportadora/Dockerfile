#FROM gradle:jdk12 as builder
#COPY --chown=gradle:gradle . /home/src
#WORKDIR /home/src
#RUN gradle build

FROM openjdk:12
ENV JAEGER_SERVICE_NAME=transportadora \
  JAEGER_ENDPOINT=http://jaeger-collector.istio-system.svc:14268/api/traces \
  JAEGER_PROPAGATION=b3 \
  JAEGER_SAMPLER_TYPE=const \
  JAEGER_SAMPLER_PARAM=1 \
  JAEGER_REPORTER_LOG_SPANS=true
#COPY --from=builder /home/src/build/libs/*.jar /app.jar
COPY ./build/libs/*.jar  /app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]

