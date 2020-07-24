#!/bin/sh
if [ -z $1 ]; then
  top
else
  $@
fi