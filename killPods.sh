#!/bin/bash

if [ -z $1 ]; then
	echo "introduce el patron de busqueda"
else
	pods=`kubectl get pod | grep $1 | awk -F" " '{print $1}'`
	for pod in $pods
	do
		kubectl delete pod $pod
	done
fi

watch "kubectl get pod | grep $1"
