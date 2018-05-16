ARG JDK_VERSION_TAG=8

FROM openjdk:${JDK_VERSION_TAG}

# Need to put ARGs after FROM
ARG LIQUIBASE_VERSION_TAG="3.5.3"
ARG MYSQLCONN_VERSION_TAG="5.1.40"

# ENV vars
ENV LIQUIBASE_VERSION ${LIQUIBASE_VERSION_TAG}
ENV MYSQLCONN_VERSION ${MYSQLCONN_VERSION_TAG}

# apply any OS updates just in case
RUN apt-get update && apt-get upgrade -y

# install liquibase
RUN \
  curl -f -o liquibase.deb -L https://github.com/liquibase/liquibase/releases/download/liquibase-parent-${LIQUIBASE_VERSION_TAG}/liquibase-debian_${LIQUIBASE_VERSION_TAG}_all.deb && \
  apt install ./liquibase.deb && \
  rm -rf /var/lib/apt/lists/* ./liquibase.deb

# install mysql-connector
RUN \
  curl -sfL -o mysql-connector-java.zip http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQLCONN_VERSION_TAG}.zip && \
  mkdir /opt/jdbc_drivers/ && \
  unzip mysql-connector-java.zip -d /opt/jdbc_drivers/ && \
  rm -f mysql-connector-java.zip && \
  chmod +x /opt/jdbc_drivers/mysql-connector-java-${MYSQLCONN_VERSION_TAG}/mysql-connector-java-${MYSQLCONN_VERSION_TAG}-bin.jar && \
  ln -s /opt/jdbc_drivers/mysql-connector-java-${MYSQLCONN_VERSION_TAG}/mysql-connector-java-${MYSQLCONN_VERSION_TAG}-bin.jar /usr/lib/liquibase-${LIQUIBASE_VERSION_TAG}/lib/

# add labels for easy identification
LABEL LIQUIBASE_VERSION=${LIQUIBASE_VERSION_TAG}
LABEL MYSQLCONN_VERSION=${MYSQLCONN_VERSION_TAG}

# add generated Dockerfile for easy viewing
ADD Dockerfile .
ADD run.sh /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/run.sh" ]
CMD [ "update" ]
LABEL GIT_COMMIT="eccd33248e3234005c74066c6e36810faef2cf62"
LABEL GIT_BRANCH="hf_new_run_script"
LABEL BUILD_DATE="20180516_132349"
