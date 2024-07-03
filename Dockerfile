FROM alpine:latest

ADD build/libs/web-proj-demo-1.0.*.jar app.jar

EXPOSE 8080

RUN apk add openjdk21-jre-headless
CMD [ "java", "-jar", "/app.jar" ]
