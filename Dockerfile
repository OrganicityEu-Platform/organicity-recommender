FROM openjdk:8-jdk
MAINTAINER thomas.gilbert@alexandra.dk

ENV PIO_VERSION 0.11.0

ENV PIO_TMP /apache-predictionio-${PIO_VERSION}-incubating
ENV PIO_HOME /PredictionIO-${PIO_VERSION}-incubating
ENV PIO_VENDORS ${PIO_HOME}/vendors
ENV PATH=${PIO_HOME}/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

ENV UR_HOME /UR

# Download + Build PredictionIO
RUN curl -O http://mirrors.rackhosting.com/apache/incubator/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz
RUN mkdir ${PIO_TMP}
RUN tar zxf apache-predictionio-${PIO_VERSION}-incubating.tar.gz -C ${PIO_TMP}
RUN rm apache-predictionio-${PIO_VERSION}-incubating.tar.gz
RUN cd ${PIO_TMP} && ./make-distribution.sh && tar zxf PredictionIO-${PIO_VERSION}-incubating.tar.gz -C /
RUN rm ${PIO_TMP}/PredictionIO-${PIO_VERSION}-incubating.tar.gz
RUN mkdir ${PIO_VENDORS}

# Spark - default processing engine for PredictionIO
RUN wget -q http://d3kbcqa49mib13.cloudfront.net/spark-1.6.3-bin-hadoop2.6.tgz
RUN tar zxf spark-1.6.3-bin-hadoop2.6.tgz -C ${PIO_VENDORS}
RUN rm spark-1.6.3-bin-hadoop2.6.tgz

# JDBC for PostgreSQL
RUN wget https://jdbc.postgresql.org/download/postgresql-42.1.4.jar -O ${PIO_HOME}/lib/postgresql-42.1.4.jar

# PredictionIO config files
ADD files/pio-env.sh ${PIO_HOME}/conf

EXPOSE 7070 8000
WORKDIR ${UR_HOME}

# Install Similar Product recommender engine template
RUN apt-get update && apt-get install -y python-pip
RUN pip install predictionio datetime requests
RUN git clone https://github.com/apache/incubator-predictionio-template-similar-product.git ${UR_HOME}
ADD files/engine.json ${UR_HOME}
# Build / download template
RUN pio build
# Overwrite test data, to copy from Organicity URL
ADD files/import_eventserver.py ${UR_HOME}/data
ADD files/boot.sh ${UR_HOME}
RUN chmod +x ${UR_HOME}/boot.sh

# Add wait-for-it
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O ${UR_HOME}/wait-for-it.sh
RUN chmod +x ${UR_HOME}/wait-for-it.sh

CMD ./boot.sh
