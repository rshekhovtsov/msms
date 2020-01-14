#!/bin/bash

#################################################################
# discovery services to monitoring and run check for each
# see details in readme.md
#################################################################

cd $(dirname "$0")/services

for service_ini  in $(ls *.ini); do
#    echo proceed $service_ini...
    bash ../msms.sh "$1" "$service_ini"
done