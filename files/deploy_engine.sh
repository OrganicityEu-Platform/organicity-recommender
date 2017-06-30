#!/bin/bash

set -e

cd /UR

# Build the engine
pio build --verbose

# Train the engine
pio train

# Deploy the engine
pio deploy
