#!/bin/bash

set -e

echo ''
echo '=======> Start PredictionIO'
pio-start-all
pio status
pio build

echo ''
echo '=======> Create new PredictionIO app'
pio app new recommenderApp
ACCESS_KEY=`pio app new recommenderApp | grep 'Access Key:' | awk '{ print $5 }'`
export ACCESS_KEY=${ACCESS_KEY}
echo 'Access key:'
echo $ACCESS_KEY

echo ''
echo '=======> Import training data'
python import_eventserver.py --access_key $ACCESS_KEY

echo ''
echo '=======> Train'
pio train -- --driver-memory 4g --executor-memory 4g

echo ''
echo '=======> Deploy'
pio deploy
