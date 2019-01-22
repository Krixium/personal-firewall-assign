#!/bin/sh

############ functions ###########
# tells the firewall to link port $1 to chain $2 for both tcp and udp
# chain $2 must already be created
account_port()
{
	iptables -A INPUT -m tcp -p tcp --sport $1 -j $2
	iptables -A INPUT -m tcp -p tcp --dport $1 -j $2
	iptables -A INPUT -m udp -p udp --sport $1 -j $2 
	iptables -A INPUT -m udp -p udp --dport $1 -j $2

	iptables -A OUTPUT -m tcp -p tcp --sport $1 -j $2
	iptables -A OUTPUT -m tcp -p tcp --dport $1 -j $2
	iptables -A OUTPUT -m udp -p udp --sport $1 -j $2 
	iptables -A OUTPUT -m udp -p udp --dport $1 -j $2
}


# globals
local_address=192.168.0.17
default_chains=(INPUT FORWARD OUTPUT)
default_policy=DROP
allow_incoming=(22 53 80 443)
allow_outgoing=(22 53 80 443)

# set default policy
for chain in ${default_chains[*]}
do
    iptables -P $chain $default_policy
done


########### generic rules ##########
# allow incoming ports
for port in ${allow_incoming[*]}
do
	# tcp
    iptables -A INPUT -m tcp -p tcp --sport $port -j ACCEPT
    iptables -A INPUT -m tcp -p tcp --dport $port -j ACCEPT
	# udp
    iptables -A INPUT -m udp -p udp --sport $port -j ACCEPT
    iptables -A INPUT -m udp -p udp --dport $port -j ACCEPT
done

# allow outgoing ports
for port in ${allow_outgoing[*]}
do
	# tcp
    iptables -A OUTPUT -m tcp -p tcp --dport $port -j ACCEPT
    iptables -A OUTPUT -m tcp -p tcp --sport $port -j ACCEPT
	# udp
    iptables -A OUTPUT -m udp -p udp --dport $port -j ACCEPT
    iptables -A OUTPUT -m udp -p udp --sport $port -j ACCEPT
done


########## special rules ##########
# drop http request from low ports
iptables -A INPUT -m tcp -p tcp --dport 80 --sport 0:1024 -j DROP
iptables -A INPUT -m udp -p udp --dport 80 --sport 0:1024 -j DROP

# drop packets with port 0
iptables -A INPUT -m tcp -p tcp --sport 0 -j DROP
iptables -A INPUT -m udp -p udp --sport 0 -j DROP
iptables -A OUTPUT -m tcp -p tcp --dport 0 -j DROP
iptables -A OUTPUT -m udp -p udp --dport 0 -j DROP


########## accounting  ##########
# create chains
iptables -N ssh
iptables -N www
iptables -A ssh -j ACCEPT
iptables -A www -j ACCEPT

account_port 80 www
account_port 443 www
account_port 22 ssh


# display iptables
iptables -L -v -n -x
