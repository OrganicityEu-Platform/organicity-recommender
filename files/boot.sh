#!/bin/bash

pio-start-all
pio status
cd /UR
pio build

pio app new recommenderApp
ACCESS_KEY=`pio app new recommenderApp | grep 'Access Key:' | awk '{ print $5 }'`

python import_eventserver.py --access_key $ACCESS_KEY

pio train -- --driver-memory 4g --executor-memory 4g
pio deploy
