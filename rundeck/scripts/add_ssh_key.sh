#!/bin/bash
# privateIPs=("10.130.100.29" "10.130.100.237" "10.130.100.206")
privateIPs=("$1")
algorithm=ecdsa

for ip in "${privateIPs[@]}"
do
    echo "Fetching $algorithm keys for $ip."
    newKeys=`(ssh-keyscan -t $algorithm $ip)`
    if [ $? -eq 0 ]; then
        newRsaKey=`(echo $newKeys | grep ecdsa-sha2)`
        if [ $? -eq 0 ]; then
            grep -vE "^$ip " ~/.ssh/known_hosts > ./tmpfile && mv ./tmpfile ~/.ssh/known_hosts && \
                echo "Deleted old $algorithm keys for $ip."
            echo $newRsaKey | tee -a ~/.ssh/known_hosts && \
                echo "Added new $algorithm keys for $ip."
        else
            echo "No keys with $algorithm encryption for $ip."
        fi
    else
        echo "Could not connect to $ip."
    fi
    echo
done
