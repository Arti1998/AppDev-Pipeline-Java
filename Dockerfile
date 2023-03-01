FROM tomcat:9.0.43-jdk11

COPY JavaMaven.war $CATALINA_HOME/webapps/
