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
```