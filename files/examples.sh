#!/bin/bash

curl -i -X POST http://localhost:7070/events.json?accessKey=$ACCESS_KEY \
-H "Content-Type: application/json" \
-d '{
  "event" : "rate",
  "entityType" : "user",
  "entityId" : "u0",
  "targetEntityType" : "item",
  "targetEntityId" : "i0",
  "properties" : {
    "rating" : 5
  }
  "eventTime" : "2014-11-02T09:39:45.618-08:00"
}'

curl -i -X POST http://localhost:7070/events.json?accessKey=$ACCESS_KEY \
-H "Content-Type: application/json" \
-d '{
  "event" : "rate",
  "entityType" : "user",
  "entityId" : "u0",
  "targetEntityType" : "item",
  "targetEntityId" : "i1",
  "properties" : {
    "rating" : 4
  }
  "eventTime" : "2014-11-02T09:39:45.618-08:00"
}'

curl -i -X POST http://localhost:7070/events.json?accessKey=$ACCESS_KEY \
-H "Content-Type: application/json" \
-d '{
  "event" : "rate",
  "entityType" : "user",
  "entityId" : "u1",
  "targetEntityType" : "item",
  "targetEntityId" : "i1",
  "properties" : {
    "rating" : 1
  }
  "eventTime" : "2014-11-02T09:39:45.618-08:00"
}'

curl -i -X POST http://localhost:7070/events.json?accessKey=$ACCESS_KEY \
-H "Content-Type: application/json" \
-d '{
  "event" : "view",
  "entityType" : "user",
  "entityId" : "u0",
  "targetEntityType" : "item",
  "targetEntityId" : "i1",
  "eventTime" : "2014-11-02T09:39:45.618-08:00"
}'

curl -i -X POST http://localhost:7070/events.json?accessKey=$ACCESS_KEY \
-H "Content-Type: application/json" \
-d '{
  "event" : "view",
  "entityType" : "user",
  "entityId" : "u1",
  "targetEntityType" : "item",
  "targetEntityId" : "i2",
  "eventTime" : "2014-11-02T09:39:45.618-08:00"
}'
