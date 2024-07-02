FROM docker.github.softwareag.com/c2e/sum-repository-service/sum-repository-service-base-image:latest

ADD build/libs/sum-repository-service-1.0.???.jar sum-repository-service.jar

EXPOSE 8080

RUN wget http://crl1.softwareag.com/Software%20AG%20Root%20CA%202020.crt -O /tmp/SAG_RootCA2020.crt --no-check-certificate && \
        $JAVA_HOME/bin/keytool -import -trustcacerts -alias SAG_RootCA2020 -file /tmp/SAG_RootCA2020.crt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit -noprompt

CMD [ "java", "-jar", "/sum-repository-service.jar" ]
