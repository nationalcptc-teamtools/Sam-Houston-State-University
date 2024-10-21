#!/bin/zsh
# assuming we are given a kali image that defaults to zsh as its shell
# this is a basic script, feel free to make changes as you see fit

if [[ $# -ne 2 ]] ; then
	echo -e "incorrect usage\n$0 <ip add> <subnet (base 10: {2,..,30})"
	echo "be careful to not enter extra spaces"
	exit 1
fi
echo -e "\n" >> scan.txt
nmap -Pn -sV $1/$2 -p >> scan.txt 2>>hopefullyempty.log

if [[ $? -ne 0 ]] ; then
	echo "something went wrong with nmap scan"
	echo "check error log"
	exit 1
fi

found="discovered.txt"

grep -o -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' scan.txt >> $found
echo "discovered hosts have been written to 'discovered.txt'"

if [[ ! -f "$found" ]] ; then
	echo "file '$found' was not created, something might have gone wrong."
fi

echo -e "\n" >> $found

original_IFS=$IFS
while IFS= read -r ip; do
	hostname=$(nslookup $ip)
	echo "$ip --> $hostname"
	echo "$ip --> $hostname" >> hostnames.txt
done < "$found"
IFS=$original_IFS
