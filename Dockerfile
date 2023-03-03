FROM maven:3.6.3-jdk-11-slim
COPY . /app
WORKDIR /app
RUN mvn clean package

FROM tomcat:9.0-jdk11-openjdk-slim
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
