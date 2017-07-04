FROM openjdk
MAINTAINER Alexandra

ENV PIO_VERSION 0.11.0
ENV SPARK_VERSION 1.6.3
ENV ELASTICSEARCH_VERSION 1.7.6
ENV HBASE_VERSION 1.3.1
ENV HADOOP_VERSION 2.6.5

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
ADD files/pio-env.sh ${PIO_HOME}/conf

# Spark - default processing engine for PredictionIO
RUN wget -q http://d3kbcqa49mib13.cloudfront.net/spark-1.6.3-bin-hadoop2.6.tgz
RUN tar zxf spark-1.6.3-bin-hadoop2.6.tgz -C ${PIO_VENDORS}
RUN rm spark-1.6.3-bin-hadoop2.6.tgz

# Elastic - storage backend for the meta data repository
RUN wget -q https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz
RUN tar zxf elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz -C ${PIO_VENDORS}
RUN rm elasticsearch-${ELASTICSEARCH_VERSION}.tar.gz

RUN echo 'cluster.name: predictionio' >> ${PIO_HOME}/vendors/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml
RUN echo 'network.host: 127.0.0.1' >> ${PIO_HOME}/vendors/elasticsearch-${ELASTICSEARCH_VERSION}/config/elasticsearch.yml

# HBase - backend of the event data repository.
RUN curl -O http://mirrors.rackhosting.com/apache/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz
RUN tar zxf hbase-${HBASE_VERSION}-bin.tar.gz -C ${PIO_VENDORS}
RUN rm hbase-${HBASE_VERSION}-bin.tar.gz
RUN mkdir ${PIO_VENDORS}/hbase-${HBASE_VERSION}/zookeeper
ADD files/hbase-site.xml ${PIO_VENDORS}/hbase-${HBASE_VERSION}/conf

RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ${PIO_VENDORS}/hbase-${HBASE_VERSION}/conf/hbase-env.sh


# PredictionIO config files
ADD files/pio-env.sh ${PIO_HOME}/conf
ADD files/deploy_engine.sh .
ADD files/entrypoint.sh .
ADD files/retrain.sh .
RUN chmod +x entrypoint.sh && chmod +x deploy_engine.sh && chmod +x retrain.sh

EXPOSE 7070 8000

# Install Similar Product recommender engine template
RUN apt-get update && apt-get install -y python-pip
RUN pip install predictionio datetime
RUN git clone https://github.com/apache/incubator-predictionio-template-similar-product.git ${UR_HOME}
ADD files/engine.json ${UR_HOME}
ADD files/import_eventserver.py ${UR_HOME}
