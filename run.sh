#!/bin/bash
set -e

function dump() {
    bash dumpcerts.sh /traefik/acme.json /output/ssl
    for crt_file in $(ls /output/ssl/certs/*); do
        pem_file=$(echo $crt_file | sed 's/certs/pem/g' | sed 's/.crt/-public.pem/g')
        echo "openssl x509 -inform PEM -in $crt_file > $pem_file"
        openssl x509 -inform PEM -in $crt_file > $pem_file
    done 
    for key_file in $(ls /output/ssl/private/*); do
        pem_file=$(echo $key_file | sed 's/private/pem/g' | sed 's/.key/-private.pem/g')
        echo "openssl rsa -in $key_file -text > $pem_file"
        openssl rsa -in $key_file -text > $pem_file
    done
}

function copy_to_proxmox() {
    cp /output/ssl/pem/*-public.pem /output/nodes/$PVE_HOST/pveproxy-ssl.pem
    cp /output/ssl/pem/*-private.pem /output/nodes/$PVE_HOST/pveproxy-ssl.key
}

mkdir -p /output/ssl/pem
# run once on start to make sure we have any old certs
dump
copy_to_proxmox

while true; do
    inotifywait -e modify /traefik/acme.json
    dump
    copy_to_proxmox
done
