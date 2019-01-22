#!/bin/bash

# Globals
default_chains=input forward output

# General rules
default_policy=drop
allow_incoming=22 80
allow_outgoing=22 80

# Set default policy
for chain in $default_chains
do
    iptables -P $chain $default_policy
done

# Allow incoming ports
for port in $allow_incoming
do
    iptables -A input -m tcp -p tcp -sport $port -j accept
done

# Allow outgoing ports
for port in $allow_outgoing
do
    iptables -A output -m tcp -p tcp -dport $port -j accept
done