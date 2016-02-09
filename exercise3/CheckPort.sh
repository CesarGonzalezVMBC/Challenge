#!/bin/bash
user="vagrant"
insecure_key="$HOMEPATH/.vagrant.d/insecure_private_key"

echo "Enter IP:port1,port2,port3..."|tee result.log
while read line
do
  IFS=':' read -a IP <<< "$line"
  IFS=',' read -a Ports <<< "${IP[1]}"
  IP=${IP[0]}
  for port in "${Ports[@]}"
	do
		echo Checking $IP:$port|tee -a result.log
		result=$(curl $IP:$port -m 5 --connect-timeout 5 2>&1)
		error=$?
		result="${result/*curl:/}"
		if [[("$error" -eq 0) || ("$error" -eq 52) || ("$error" -eq 56)]]
		then
			echo Connection OK|tee -a result.log
		else
					
			if [[("$error" -eq 28)]] && [ ${result:5:11} = "Connection" ]
			then
				echo Connection to $IP failed|tee -a result.log
			else
				if [[("$error" -eq 28)]] && [ ${result:5:10} = "Operation" ]
				then
					echo Connection OK|tee -a result.log
				else
					case $port in
						80) ssh -i $insecure_key $user@$IP -o "StrictHostKeyChecking no" "sudo service apache2 start"|tee -a result.log;;
						3306) ssh -i $insecure_key $user@$IP -o "StrictHostKeyChecking no" "sudo service mysql start"|tee -a result.log;;
						*) echo Service port not in the list
					esac
				fi
			fi
		fi
	done
echo
echo "Enter IP:port1,port2,port3...(crtl+c to exit)"|tee -a result.log
done < "${1:-/dev/stdin}"
echo Check finished|tee -a result.log