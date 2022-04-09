#!/bin/bash

docker kill $(docker ps -q)
docker container prune --force
