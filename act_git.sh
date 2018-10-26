#!/bin/bash

if [ "$1" = "" ] || [ "$2" = "" ]
then
	echo "uso: act_git.sh nombre_rama comentario"
	exit 1
fi

git add .
git commit -m "$2"
git push -u origin $1
