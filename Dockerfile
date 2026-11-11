
FROM maven:3.9.0-eclipse-temurin-8 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -B clean package -DskipTests

FROM tomcat:9.0-jdk8-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

RUN sed -i 's/port="8080"/port="10000"/' \
    /usr/local/tomcat/conf/server.xml
COPY --from=build /app/target/QueueLess1-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/queueless.war

EXPOSE 10000

CMD ["catalina.sh", "run"]

