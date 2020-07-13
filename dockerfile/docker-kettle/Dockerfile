FROM openjdk:8u212-jre-alpine3.9
LABEL maintainer="surenkids@gmail.com"

# Init ENV
ENV PENTAHO_VERSION=8.3 \
    PENTAHO_TAG=8.3.0.0-371 \
    MYSQL_CONNECTOR_VERSION=5.1.48 \
    KETTLE_HOME="/home/pentaho"

RUN mkdir -p ${KETTLE_HOME}
WORKDIR ${KETTLE_HOME}

# Get and unpack pdi-ce
# http://downloads.sourceforge.net/project/pentaho/Data%20Integration/${PENTAHO_VERSION}/pdi-ce-${PENTAHO_TAG}.zip
RUN wget http://downloads.sourceforge.net/project/pentaho/Pentaho%20${PENTAHO_VERSION}/client-tools/pdi-ce-${PENTAHO_TAG}.zip \
    && unzip pdi-ce-${PENTAHO_TAG}.zip \
    && rm -f pdi-ce-${PENTAHO_TAG}.zip

# Add mysql connector
RUN wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.zip \
    && unzip mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.zip \
    && cp mysql-connector-java-${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}-bin.jar ${KETTLE_HOME}/data-integration/lib/ \
    && rm -R mysql-connector-java-${MYSQL_CONNECTOR_VERSION} \
    && rm mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.zip

EXPOSE 8282

CMD ["${KETTLE_HOME}/data-integration/carte.sh", "0.0.0.0", "8282"]
#EXPOSE 8080
#ENTRYPOINT ["sh", "-c", "${PENTAHO_HOME/scripts/run.sh"]