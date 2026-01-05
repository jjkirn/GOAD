#!/bin/bash
# Resolve hostname from /etc/hosts and connect via proxychains

HOST=$1
IP=$(grep -w "$HOST" /etc/hosts | awk '{print $1}')

if [ -z "$IP" ]; then
    echo "Host $HOST not found in /etc/hosts"
    exit 1
fi

echo "Connecting to $HOST ($IP)..."
proxychains4 evil-winrm -i $IP -u vagrant -p vagrant

