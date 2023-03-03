FROM maven:3.6.3-jdk-11-slim
COPY . /app
WORKDIR /app
COPY pom.xml .
RUN mvn clean install
CMD ["mvn", "tomcat7:run"]
