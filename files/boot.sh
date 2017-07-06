#!/bin/bash

set -e

cd /UR

echo ''
echo '=======> Start PredictionIO'
pio-start-all
pio status
pio build

echo ''
echo '=======> Create new PredictionIO app'
pio app new recommenderApp
AK2=$(pio app list)
ACCESS_KEY=$(echo $AK2 | grep -oEi 'recommenderApp .* \(all\)' | awk '{print $5}')
export ACCESS_KEY=${ACCESS_KEY}
echo 'Access key:'
echo $ACCESS_KEY

echo ''
echo '=======> Import training data'
python /UR/import_eventserver.py --access_key $ACCESS_KEY

echo ''
echo '=======> Train'
pio train -- --driver-memory 4g --executor-memory 4g

echo ''
echo '=======> Deploy'
pio deploy
