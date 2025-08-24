#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

# Update Ownership

sudo chown -R vscode:vscode /home/vscode/

# Configure Firewall

ALLOWED_DOMAINS=(
    "registry.npmjs.org"
    "api.anthropic.com"
    "sentry.io"
    "statsig.anthropic.com"
    "statsig.com"
)

sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo ipset destroy allowed-domains 2>/dev/null || true

sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A INPUT -p udp --sport 53 -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

sudo ipset create allowed-domains hash:net

gh_ranges=$(curl -s https://api.github.com/meta)

while read -r cidr; do
    sudo ipset add allowed-domains "$cidr"
done < <(echo "$gh_ranges" | jq -r '(.web + .api + .git)[]' | aggregate -q)

for domain in "${ALLOWED_DOMAINS[@]}"; do
    ips=$(dig +noall +answer A "$domain" | awk '$4 == "A" {print $5}')
    
    while read -r ip; do
        sudo ipset add allowed-domains "$ip"
    done < <(echo "$ips")
done

HOST_IP=$(ip route | grep default | cut -d" " -f3)
HOST_NETWORK=$(echo "$HOST_IP" | sed "s/\.[0-9]*$/.0\/24/")

sudo iptables -A INPUT -s "$HOST_NETWORK" -j ACCEPT
sudo iptables -A OUTPUT -d "$HOST_NETWORK" -j ACCEPT

sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

sudo iptables -A OUTPUT -m set --match-set allowed-domains dst -j ACCEPT