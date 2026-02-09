#!/bin/bash

# ==========================================================
# SQUID PROXY INSTALL & CONFIG SCRIPT - CENTOS 9
# Blocks Facebook & YouTube + enables monitoring
# ==========================================================

set -e

# echo "Updating system packages..."
# dnf update -y

echo "Installing Squid proxy..."
dnf install squid -y

echo "Backing up original squid.conf..."
cp /etc/squid/squid.conf /etc/squid/squid.conf.bak

echo "Creating blocked websites list..."
cat <<EOF > /etc/squid/blocked_sites.txt
.facebook.com
.youtube.com
EOF

echo "Configuring squid..."

cat <<'EOF' > /etc/squid/squid.conf
# ==============================
# SQUID BASIC CONFIGURATION
# ==============================

# Define local network (change if needed)
acl localnet src 10.0.0.0/8
acl localnet src 172.16.0.0/12
acl localnet src 192.168.159.0/24

# Safe ports
acl SSL_ports port 443
acl Safe_ports port 80
acl Safe_ports port 443
acl Safe_ports port 21
acl Safe_ports port 1025-65535

acl CONNECT method CONNECT

# Blocked domains
acl blocked_sites dstdomain "/etc/squid/blocked_sites.txt"

# Access rules
http_access deny blocked_sites
http_access allow localnet
http_access allow localhost
http_access deny all

# Squid listens on this port
http_port 3128

# Logging for monitoring
access_log /var/log/squid/access.log squid
cache_log /var/log/squid/cache.log

# Performance settings
cache_mem 256 MB
maximum_object_size 100 MB
cache_dir ufs /var/spool/squid 1000 16 256

coredump_dir /var/spool/squid
EOF

echo "Setting permissions..."
chown -R squid:squid /var/log/squid
chown -R squid:squid /var/spool/squid

echo "Initializing cache directories..."
squid -z

echo "Enabling and starting Squid service..."
systemctl enable squid
systemctl restart squid

echo "Configuring firewall..."
firewall-cmd --permanent --add-port=3128/tcp
firewall-cmd --reload

echo "Verifying service status..."
systemctl status squid --no-pager

echo "================================================="
echo "SQUID Proxy Installed & Running"
echo "Proxy Port: 3128"
echo "Blocked: Facebook, YouTube"
echo "Logs: /var/log/squid/access.log"
echo "================================================="
