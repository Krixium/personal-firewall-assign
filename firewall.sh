#!/bin/sh

# globals
TCP='-m tcp -p tcp'
UDP='-m udp -p udp'
default_policy=DROP
default_chain_policy=DROP
default_chains=(INPUT FORWARD OUTPUT)
chain_names=(ssh www)

############ functions ###########
# sends all traffic from port $1 to chain $2
# chain $2 must already be created
link_port_to_chain()
{
    iptables -A INPUT $TCP --sport $1 -j $2
    iptables -A INPUT $TCP --dport $1 -j $2
    iptables -A INPUT $UDP --sport $1 -j $2
    iptables -A INPUT $UDP --dport $1 -j $2

    iptables -A OUTPUT $TCP --sport $1 -j $2
    iptables -A OUTPUT $TCP --dport $1 -j $2
    iptables -A OUTPUT $UDP --sport $1 -j $2
    iptables -A OUTPUT $UDP --dport $1 -j $2
}

# accepts any packet, tcp or udp, on chain $2 with port $1
accept_port_on_chain()
{
    iptables -A $2 $TCP --sport $1 -j ACCEPT
    iptables -A $2 $TCP --dport $1 -j ACCEPT
    iptables -A $2 $UDP --sport $1 -j ACCEPT
    iptables -A $2 $UDP --dport $1 -j ACCEPT
}

# set default policy
echo "setting default policy ..."
for chain in ${default_chains[*]}
do
    iptables -P $chain $default_policy
done

# create account chains and set the default chain policy
echo "creating accounting chains ..."
for c in ${chain_names[*]}
do
    iptables -N $c
done

# redirect default chains to accounting chains
echo "linking accounting chains ..."
link_port_to_chain 22 ssh
link_port_to_chain 80 www
link_port_to_chain 443 www

# setting generic rules
echo "setting generic rules ..."
accept_port_on_chain 53 INPUT
accept_port_on_chain 53 OUTPUT
accept_port_on_chain 67:68 INPUT
accept_port_on_chain 67:68 OUTPUT

accept_port_on_chain 22 ssh
accept_port_on_chain 80 www
accept_port_on_chain 443 www

# special rules
echo "setting special rules ..."
iptables -A INPUT $TCP --sport 0 -j DROP
iptables -A INPUT $UDP --sport 0 -j DROP
iptables -A OUTPUT $TCP --dport 0 -j DROP
iptables -A OUTPUT $UDP --dport 0 -j DROP
iptables -A www $TCP --dport 80 --sport 0:1023 -j DROP
iptables -A www $UDP --dport 80 --sport 0:1023 -j DROP

# display iptables
echo "displaying tables ..."
iptables -L -xvn
