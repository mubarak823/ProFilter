echo Enter Isp Asn :
read asn
echo Enter Port:
read PortTo
m_respone=`curl -X POST "https://api.spyse.com/v4/data/ip/search" \
    -H "accept: application/json" \
    -H "Authorization: Bearer e76fc517-5f98-460d-83fa-e671d5fc2c56" \
    -H "Content-Type: application/json" \
    -d "{\"limit\":100,\"offset\":0,\"search_params\":[{\"open_port\":{\"operator\":\"exists\"}},{\"as_num\":{\"operator\":\"eq\",\"value\":\"$asn\"}}],\"query\":\"\"}"`
touch respo.txt
echo $m_respone>respo.txt
declare -i count=`jq '.data.total_items' respo.txt`
declare -i limit=$(( count-1 ))
rm $asn".txt"
touch $asn".txt"
for (( i=0;i<$limit;i++ )) 
do
	ItemIp=`jq '.data.items['$i'].ip' respo.txt`
	ItemIp="${ItemIp//\"}"
	if [[ $ItemIp = null ]]; then
		break
	fi
	echo $ItemIp>>$asn".txt"
	echo Add $ItemIp To $asn".txt"
	
done
echo Scan Ports yes/no:
read scan_port
if [[ $scan_port = yes ]]; then
	nmap -iL $asn".txt" -p $PortTo
else
	exit
fi
