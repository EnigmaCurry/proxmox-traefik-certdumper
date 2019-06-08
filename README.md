# traefik certificate dumper for proxmox admin dashboard

```
version: '2'

services:
  certdumper:
    image: enigmacurry/traefik-certdumper:latest
    volumes:
      - /etc/containers/traefik:/traefik
      - /etc/pve/ssl:/output
    restart: always
    privileged: true			      
    environment:
      CERTIFICATE: *.gtown.lan.rymcg.tech
      PVE_HOST: stardust
```

Change CERTIFICATE to the name of the certificate (which is the domain name by default)

Change PVE_HOST to the hostname of your proxmox server.

Writes traefik public ssl cert to `/etc/pve/nodes/$PVE_HOST/pveproxy-ssl.pem` and the key to `/etc/pve/nodes/$PVE_HOST/pveproxy-ssl.key`
