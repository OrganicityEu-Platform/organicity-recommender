#!/bin/bash

##
## See
## https://predictionio.incubator.apache.org/deploy/#update-model-with-new-data
##
## crontab:
## 0 0 * * *   /retrain.sh >/dev/null 2>/dev/null
##

set -e

pio train -- --driver-memory 4g --executor-memory 4g
pio deploy
