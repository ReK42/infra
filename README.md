# Podman-based Infrastructure Host
## Bootstrap
```bash
podman network create caddy
podman compose --file caddy.yml --env-file .env.caddy up --detach
podman compose --file portainer.yml --env-file .env.portainer up --detach
```

