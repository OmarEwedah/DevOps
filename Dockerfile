FROM maven

COPY hello-world /home/hello-world
WORKDIR /home/hello-world/

EXPOSE 8080

CMD mvn spring-boot:run
