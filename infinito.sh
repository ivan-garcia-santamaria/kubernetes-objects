

ficheroWaitForComplete="/tmp/waitForComplete.txt"

grep -R waitForComplete\(\) | awk -F":" '{print $1}' | sort | uniq | awk -F"/" '{print $4}' | awk -F"." '{print $1}' > $ficheroWaitForComplete

while IFS='' read -r linea || [[ -n "$linea" ]]; do
   fichero="apiproxy/policies/$linea.xml"
   if [ -f $fichero ];
   then
	tiempo=`cat $fichero | grep timeLimit | awk -F" " '{for (i = 1; i <= NF; i++) { if ($i ~ "timeLimit") print $i}}'`
   else
	tiempo="OJO QUE NO EXISTE POLICY"
   fi
   printf ">%s waitForComplete(): %s<\n" "$linea" "$tiempo"
done < $ficheroWaitForComplete
