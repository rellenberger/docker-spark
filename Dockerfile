# base python image
FROM python:3.13.0-slim-bookworm

# update packages, then install without prompts: java, wget, tar, rsync, ssh
RUN apt-get update && apt-get install -y default-jre wget tar rsync ssh

# create environment variables for spark home directory; add bin/sbin directories to path to allow spark scripts to run without full reference
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

ENV SPARK_VERSION=3.5.3

# create spark directory, download/extract/remove tar 
RUN mkdir -p $SPARK_HOME \
    && wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz \
    && tar -xzf spark-$SPARK_VERSION-bin-hadoop3.tgz --directory $SPARK_HOME --strip-components 1 \
    && rm spark-$SPARK_VERSION-bin-hadoop3.tgz

# set scripts as executable
RUN chmod u+x $SPARK_HOME/sbin/* \
    && chmod u+x $SPARK_HOME/bin/*

# define master address, to be referenced by engines
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

# Install python libraries from requirements.txt file
COPY requirements.txt .
RUN pip3 install -r requirements.txt

COPY spark-defaults.conf "$SPARK_HOME/conf"