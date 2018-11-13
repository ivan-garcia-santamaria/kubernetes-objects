#!/bin/bash

DIR=`pwd`

echo $DIR

scripts=$( cat scripts.txt )
for script in $scripts
do
   echo "Haciendo el link para "$script
   sudo ln -s $DIR/$script /usr/local/bin/$script
done

