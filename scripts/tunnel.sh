#!/bin/bash
ssh -D 9050 -L 5601:192.168.56.50:5601 -L 9200:192.168.56.50:9200 -f -N -o ServerAliveInterval=60 -o ServerAliveCountMax=3 jim@192.168.1.110
echo "Tunnel established!"
echo "- SOCKS proxy on port 9050"
echo "- ELK Kibana forwarded to localhost:5601"
echo "- ELK Elasticsearch forwarded to localhost:9200"
ss -tulnp | grep -E '9050|5601|9200'

