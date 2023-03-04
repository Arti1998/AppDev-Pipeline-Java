FROM maven:3.6.3-jdk-11-slim
COPY . /app
WORKDIR /app
RUN mvn clean package

FROM tomcat
COPY --from=0 /app/target/mvn-hello-world.war /usr/local/tomcat/webapps/mvn-hello-world.war
CMD ["catalina.sh", "run"]
