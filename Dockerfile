FROM maven:3.6.0-jdk-11-slim AS build

COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean install

#RUN apt-get update
#RUN apt-get install -y gss-ntlmssp

RUN update-ca-certificates
RUN sed -i '/^ssl_conf = ssl_sect$/s/^/#/' /etc/ssl/openssl.cnf


#
# Run stage
#
FROM adoptopenjdk/openjdk11:alpine-slim
COPY --from=build /home/app/target/oficina-backend.jar /usr/local/lib/oficina-backend.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/usr/local/lib/oficina-backend.jar"]

