#!/bin/bash
ssh -D 8080 -f -N -o ServerAliveInterval=60 -o ServerAliveCountMax=3 jim@192.168.1.110
echo "Tunnel established on port 8080!"
ss -tulnp
