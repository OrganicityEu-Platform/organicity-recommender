#!/bin/bash

function pioStatus() {
  echo 'Read pio status - i.e. is there a database connection etc.'
  PS=$(pio status | grep 'Your system is all ready to go')
  if [ -z "$PS" ]
  then
    PIO_STATE=0
  else
    PIO_STATE=1
  fi
  echo 'pio status: ' $PIO_STATE
}

function readAccessKey() {
  AK2=$(pio app list)
  ACCESS_KEY=$(echo $AK2 | grep -oEi 'recommenderApp .* \(all\)' | awk '{print $5}')
}

pioStatus
if [ "$PIO_STATE" -eq "0" ]
then
  echo ''
  echo '=======> Cannot start PredictionIO'
  set -e
  exit 1
else
  echo ''
  echo '=======> PredictionIO ready to start'
  set -e
  pio eventserver &
fi

echo ''
echo '=======> Checkin existing app key'
readAccessKey
echo 'Access key:'
echo $ACCESS_KEY
if [ $ACCESS_KEY ]
then
  echo 'Existing pio app - only calling train and deploy'
  echo ''
  echo '=======> Train'
  pio train -- --driver-memory 4g --executor-memory 4g
  echo ''
  echo '=======> Deploy'
  pio deploy
else
  echo 'Creating new pio app - including import, train and deploy'
  if [ $INITIAL_ACCESS_KEY ]
  then
    pio app new --access-key $INITIAL_ACCESS_KEY recommenderApp
  else
    pio app new recommenderApp
  fi
  readAccessKey
  echo ''
  echo '=======> Import training data'
  python data/import_eventserver.py --access_key $ACCESS_KEY
  echo ''
  echo '=======> Train'
  pio train -- --driver-memory 4g --executor-memory 4g
  echo ''
  echo '=======> Deploy'
  pio deploy
fi
