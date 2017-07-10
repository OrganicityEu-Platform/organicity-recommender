#!/bin/bash

function pioStatus() {
  echo '*** read piostatus'
  PS=$(pio status | grep 'Your system is all ready to go')
  if [ -z "$PS" ]
  then
    PIOSTATUS=0
  else
    PIOSTATUS=1
  fi
}

function readAccessKey() {
  AK2=$(pio app list)
  ACCESS_KEY=$(echo $AK2 | grep -oEi 'recommenderApp .* \(all\)' | awk '{print $5}')
}


cd /UR

pioStatus
if [ "$PIOSTATUS" -eq "0" ]
then
  echo ''
  echo '=======> Start PredictionIO'
  set -e
  pio-stop-all
  pio-start-all
  pio status
  pio build
else
  echo ''
  echo '=======> PredictionIO already started'
fi

echo ''
echo '=======> Create new PredictionIO app'
readAccessKey
echo 'Access key:'
echo $ACCESS_KEY
if [ $ACCESS_KEY ]
then
  echo 'Existing pio app'
else
  echo 'Creating new pio app'
  pio app new recommenderApp
  readAccessKey
  echo ''
  echo '=======> Train'
  pio train -- --driver-memory 4g --executor-memory 4g
  echo ''
  echo '=======> Deploy'
  pio deploy
fi
