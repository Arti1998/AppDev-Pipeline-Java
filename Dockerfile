FROM maven:3.6.3-jdk-11-slim
COPY . /app
WORKDIR /app
RUN mvn clean package

FROM tomcat
ADD app/target/JavaMaven.war /usr/local/tomcat/webapps/JavaMaven.war
CMD ["catalina.sh", "run"]
