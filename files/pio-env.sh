#!/usr/bin/env bash

PIO_FS_BASEDIR=${HOME}/.pio_store
PIO_FS_ENGINESDIR=${PIO_FS_BASEDIR}/engines
PIO_FS_TMPDIR=${PIO_FS_BASEDIR}/tmp

# SPARK_HOME: Apache Spark is a hard dependency and must be configured.
# SPARK_HOME=$PIO_HOME/vendors/spark-2.0.2-bin-hadoop2.7
SPARK_HOME=$PIO_HOME/vendors/spark-1.6.3-bin-hadoop2.6

POSTGRES_JDBC_DRIVER=$PIO_HOME/lib/postgresql-42.1.4.jar

# Default is to use PostgreSQL
PIO_STORAGE_REPOSITORIES_METADATA_NAME=pio_meta
PIO_STORAGE_REPOSITORIES_METADATA_SOURCE=PGSQL

PIO_STORAGE_REPOSITORIES_EVENTDATA_NAME=pio_event
PIO_STORAGE_REPOSITORIES_EVENTDATA_SOURCE=PGSQL

PIO_STORAGE_REPOSITORIES_MODELDATA_NAME=pio_model
PIO_STORAGE_REPOSITORIES_MODELDATA_SOURCE=PGSQL

# PostgreSQL Default Settings
# Please change "pio" to your database name in PIO_STORAGE_SOURCES_PGSQL_URL
# Please change PIO_STORAGE_SOURCES_PGSQL_USERNAME and
# PIO_STORAGE_SOURCES_PGSQL_PASSWORD accordingly
PIO_STORAGE_SOURCES_PGSQL_TYPE=jdbc
PIO_STORAGE_SOURCES_PGSQL_URL=jdbc:postgresql://db/pio
PIO_STORAGE_SOURCES_PGSQL_USERNAME=admin
PIO_STORAGE_SOURCES_PGSQL_PASSWORD=1234
PIO_STORAGE_SOURCES_PGSQL_INDEX=enabled
