FROM openjdk:11 AS BUILD_IMAGE
RUN apt update && apt install maven -y
RUN git clone https://github.com/ibmkuyucu/vprofile.git
COPY resources/application.properties /vprofile/src/main/resources/
RUN cd vprofile && mvn install

FROM tomcat:9-jre11
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE vprofile/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

VOLUME /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties

EXPOSE 8080
CMD ["catalina.sh","run"]
