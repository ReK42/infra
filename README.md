# Podman-based Infrastructure Host
## Bootstrap
1. Clone this repository
1. Start Portainer: `sudo ./init.sh start`
1. You can now reach Portainer at `https://<hostname>:9443`
1. Deploy the `proxy` stack via Portainer using gitops
1. You can now reach Portainer at `https://portainer.<domain>`
1. Deploy the remaining stacks via Portainer using gitops
