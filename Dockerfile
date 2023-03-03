FROM maven:3.6.3-jdk-11-slim
COPY . /app
WORKDIR /app
COPY pom.xml . /app
COPY .dockerignore /app
RUN mvn clean install
CMD ["mvn", "tomcat7:run"]
