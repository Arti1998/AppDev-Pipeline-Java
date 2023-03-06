#FROM maven:3.6.3-jdk-11-slim
#COPY . /app
#WORKDIR /app
#RUN mvn clean package

FROM tomcat
ADD JavaMaven.war /usr/local/tomcat/webapps/JavaMaven.war
#COPY --from=0 /app/target/mvn-hello-world.war /usr/local/tomcat/webapps/mvn-hello-world.war
EXPOSE 8081
#CMD ["catalina.sh", "run"]
