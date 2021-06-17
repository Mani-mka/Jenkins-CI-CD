# Pull base image 
From tomcat:8-jre8 

# copy war file on to container 
COPY ./target/Tomcat_war.war /usr/local/tomcat/webapps
