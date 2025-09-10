# Builder image
FROM docker.io/caddy:${CADDY_VERSION}-builder AS builder
RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/mholt/caddy-dynamicdns \
    --with github.com/caddy-dns/rfc2136

# Final image
FROM docker.io/caddy:${CADDY_VERSION}-alpine
RUN apk add nss-tools  # Required for self-signed certificates
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "docker-proxy"]
