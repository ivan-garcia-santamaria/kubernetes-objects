#!/bin/bash

ficheroWaitForComplete="/tmp/timeLimits.txt"

ficheroWaitForCompleteLimits="/tmp/timeLimits.csv"

if [ -f $ficheroWaitForCompleteLimits ]
then 
	rm $ficheroWaitForCompleteLimits
fi

grep -R timeLimit=\"0\" | awk -F":" '{print $1}' | sort | uniq | awk -F"/" '{print $3}' | awk -F"." '{print $1}' > $ficheroWaitForComplete

while IFS='' read -r linea || [[ -n "$linea" ]]; do
   endpoint=`grep -n $linea apiproxy/proxies/*`
   ficheroEndpoint=`grep -l $linea apiproxy/proxies/*`
   if [ "$ficheroEndpoint" != "" ]
   then
   	basePath=`grep BasePath $ficheroEndpoint* | sort | awk -F"/" '{print $2"/"$3"/"$4}' | awk -F"<" '{print $1}'`
   fi
   echo $basePath
   #printf ">%s timeLimits: %s<\n" "$linea" "$basePath"
   printf "%s;%s;%s;%s\n" "$linea" "$tiempo" "$basePath" "$endpoint"  >> $ficheroWaitForCompleteLimits
done < $ficheroWaitForComplete
