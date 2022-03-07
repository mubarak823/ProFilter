#!/bin/bash
clear
echo Enter Your Domain :
read host
read -p "Start From : " StartF
Work () {                                                  request=`curl --silent -X POST "https://api.spyse.com/v4/data/domain/search" \
    -H "accept: application/json" \
    -H "Authorization: Bearer 27c8f98f-19ac-44fb-a743-b96cc053258d" \
    -H "Content-Type: application/json" \
    -d "{\"limit\":100,\"offset\":$StartF,\"search_params\":[{\"name\":{\"operator\":\"ends\",\"value\":\".$host\"}}],\"query\":\"\"}"`
	
touch subdo_result.txt                                       
echo $request>subdo_result.txt                               
declare -i n_results=`jq '.data.total_items' subdo_result.txt`
            echo $n_results Result Founded
subdoGen=$host"_subdo_s"$StartF".txt"
rm -f $subdoGen
            
touch $subdoGen
for (( i=0;i<$n_results;i++ ))                             do
        Ip=`jq '.data.items['$i'].name' subdo_result.txt`
        Ip="${Ip//\"}"
        if [ $Ip = null ]; then
                break
        fi
        echo $Ip>>$subdoGen
        echo $Ip Added To $subdoGen
done
echo Ports To Scan Seperated by , :
read PortTo
if [ $PortTo = ""]; then
	echo No Port
	./main.sh
else 
	nmap -iL $subdoGen -p $PortTo
	exit
fi
}
echo "Searching..."
Work
