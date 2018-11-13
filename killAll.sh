#!/bin/bash

if [ -z $1 ]; then
	echo "introduce el patron de busqueda"
else
	elementos=`kubectl get all | grep $1 | sort | awk -F" " '{print $1}'`
	for elemento in $elementos
	do
		kubectl delete $elemento
	done
fi
