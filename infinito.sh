#!/bin/bash

ficheroWaitForComplete="/tmp/waitForComplete.txt"

ficheroWaitForCompleteLimits="/tmp/waitForCompleteLimits.csv"

if [ -f $ficheroWaitForCompleteLimits ]
then 
	rm $ficheroWaitForCompleteLimits
fi

#grep -R waitForComplete\(\) | awk -F":" '{print $1}' | sort | uniq | awk -F"/" '{print $4}' | awk -F"." '{print $1}' > $ficheroWaitForComplete
grep -R waitForComplete | awk -F":" '{print $1}' | sort | uniq | awk -F"/" '{print $4}' | awk -F"." '{print $1}' > $ficheroWaitForComplete

while IFS='' read -r linea || [[ -n "$linea" ]]; do
   fichero="apiproxy/policies/$linea.xml"
   if [ -f $fichero ];
   then
	tiempo=`cat $fichero | grep timeLimit | awk -F" " '{for (i = 1; i <= NF; i++) { if ($i ~ "timeLimit") print $i}}'`
   else
	tiempo="OJO QUE NO EXISTE POLICY"
   fi
   endpoint=`grep -n $linea apiproxy/proxies/*`
   ficheroEndpoint=`grep -l $linea apiproxy/proxies/*`
   if [ "$ficheroEndpoint" != "" ]
   then
   	basePath=`grep BasePath $ficheroEndpoint* | sort | awk -F"/" '{print $2"/"$3"/"$4}' | awk -F"<" '{print $1}'`
   fi
   printf ">%s waitForComplete(): %s<\n" "$linea" "$tiempo"
   printf "%s;%s;%s;%s\n" "$linea" "$tiempo" "$basePath" "$endpoint"  >> $ficheroWaitForCompleteLimits
done < $ficheroWaitForComplete
