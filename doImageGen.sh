#!/bin/bash

if [ "$1" = "" ]
then
    echo "se necesita el nombre para el uso de los objetos"
    exit 1
fi

nombre=$1

mvn clean package -DskipTests

tagGC=`docker images | grep $nombre |awk -v nombre=$nombre -F" " '{if ($1=="eu.gcr.io/transformacion-it/"nombre) {print $3}}'`
if [ "$tagGC" != "" ]
then
	echo "Borrando la imagen anterior "$tagGC
	docker rmi $tagGC -f
fi

echo "Creando la imagen...."
docker build -t $nombre .

tag=`docker images | grep $nombre |awk -v nombre=$nombre -F" " '{if ($1==nombre) {print $3}}'`
echo "Creando tag imagen: "$tag
docker tag $tag eu.gcr.io/transformacion-it/$nombre:1.0.0

echo "Subiendo a Google Cloud..."
docker push eu.gcr.io/transformacion-it/$nombre:1.0.0

kubectl config set-context $(kubectl config current-context) --namespace=pocs-lab

pod=`kubectl get pod | grep $nombre | awk -F" " '{print $1}'`
if [ "$pod" != "" ]
then
	echo "Borrando el POD "$pod
	kubectl delete pod $pod
else
	#echo "Creamos deployment"
	#kubectl run $nombre --replicas=1 --labels="app=$nombre" --image=eu.gcr.io/transformacion-it/$nombre:1.0.0 --port=8080
	#echo "Creamos el service"
	#kubectl expose deployment $nombre --target-port=8080 --type=ClusterIP --name=$nombre
	echo "Creamos el all in one"
	DIR="$(cd "$(dirname "$0")" && pwd)"
        . $DIR/all_in_one.sh $nombre > /tmp/k8_temp.yaml	
	echo "Creamos los objetos en kubernetes"
	kubectl create -f /tmp/k8_temp.yaml

fi
watch kubectl get pod

pod=`kubectl get pod | grep $nombre | awk -F" " '{print $1}'`

kubectl logs -f $pod
