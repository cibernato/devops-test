# Stage 1: Build app
FROM alpine:3.20 AS build

RUN mkdir /tmp/app

WORKDIR /tmp/app

COPY . .

RUN apk add --no-cache openjdk17=17.0.16_p8-r0 \
    maven=3.9.6-r0 \
    && mvn clean package -DskipTests

# Stage 2: Run app with non-root user
FROM alpine:3.20

RUN apk add --no-cache openjdk17=17.0.16_p8-r0 curl

# non-root user
RUN addgroup -g 5000 appgroup
RUN adduser -G appgroup -u 5000 -h /home/appuser -D appuser
RUN mkdir /tmp/app

WORKDIR /tmp/app

COPY --from=build /tmp/app/target/*.jar app.jar

RUN chown -R appuser:appgroup /tmp/app

USER appuser

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3  \
    CMD curl http://localhost:8000/api/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]

CMD ["--server.port=8000"]