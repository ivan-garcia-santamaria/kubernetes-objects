#!/bin/bash

if [ "$1" = "" ]
then
	echo "se necesita el nombre para el uso de los objetos"
	exit 1
fi

IFS=
objetos="$(cat <<EOF
apiVersion: v1
kind: Service
metadata:
  labels:
    app: $1
  name: $1
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: $1
  type: ClusterIP
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: $1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: $1
  template:
    metadata:
      labels:
        app: $1
    spec:
      containers:
      - image: eu.gcr.io/transformacion-it/$1:1.0.0
        imagePullPolicy: Always
        name: $1
        ports:
        - containerPort: 8080
          protocol: TCP
EOF
)"

echo $objetos
