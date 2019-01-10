#!/bin/bash

if [ "$1" = "" ]
then
    echo "se necesita el nombre del namespace"
    exit 1
fi

kubectl config set-context $(kubectl config current-context) --namespace=$1
