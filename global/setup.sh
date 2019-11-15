hosts=$(cat /global/hosts)
ip=$(cat /global/ip)
hosts_count=$(cat /global/hosts | wc -l)
echo "127.0.0.1 localhost" >> /etc/hosts
for n in $( seq 1 $hosts_count)
do
    domain=$(cat /global/hosts | grep '' | sed -n "${n}p")
    if [ "$domain" != "" ]; then
        echo "$ip $domain" >> /etc/hosts
    fi
done