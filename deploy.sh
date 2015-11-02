#!/bin/bash
set -e
cd "`dirname $0`"

PROJECT="$1"

./create.sh $PROJECT
./initialize.sh $PROJECT
./start.sh $PROJECT

sudo nginx reload

./info.sh $PROJECT