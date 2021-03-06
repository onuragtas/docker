hosts=$(cat /global/hosts)
ip=$(cat /global/ip)
dockerip=$(cat /global/dockerip)
hosts_count=$(cat /global/hosts | wc -l)
echo "127.0.0.1 localhost" > /etc/hosts
for n in $( seq 1 $hosts_count)
do
    ip_domain=$(cat /global/hosts | grep '' | awk '{print $1}' | sed -n "${n}p")
    domain=$(cat /global/hosts | grep '' | awk '{print $2}' | sed -n "${n}p")
    if [ "$domain" != "" ] && [ "$ip_domain" == "$dockerip" ]; then
        check=$(cat /etc/hosts | grep "$ip $domain")
        if [ "$check" == "" ]; then
          echo "$ip $domain" >> /etc/hosts
        fi
    else
        check=$(cat /etc/hosts | grep "$ip_domain $domain")
        if [ "$check" == "" ]; then
          echo "$ip_domain $domain" >> /etc/hosts
        fi
    fi
done