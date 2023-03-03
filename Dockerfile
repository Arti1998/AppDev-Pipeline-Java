FROM maven:3.6.3-jdk-11-slim
COPY . /app
WORKDIR /app
RUN mvn clean package

FROM tomcat:8-jre8-alpine
COPY --from=build /app/*.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
