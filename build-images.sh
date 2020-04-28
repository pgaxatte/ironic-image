docker build -t ironic-base:latest -f Dockerfile.base . && \
docker build -t docker.io/pgaxatte/ovh-metal3-ironic:latest -f Dockerfile .
