FROM maven

COPY hello-world-master /home/hello-world-master
WORKDIR /home/hello-world-master/

EXPOSE 8080

CMD mvn spring-boot:run
