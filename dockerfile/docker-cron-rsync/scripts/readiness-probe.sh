#!/bin/sh

myDeploy="/root/last-full-pull.ktsee"

if [ -f "$myDeploy" ]; then
  echo 'Deploy success'
  exit 0
else
  echo 'Deploying...'
  exit 1
fi