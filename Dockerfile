#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
#                                                           #
#  888888 8888888              88 8888888                   #
#    88   88                   88 88    oo                  #
#    88   88                   88 88                        #
#    88   88888 .d8b.   .d8b.  88 88888 88 8888b.  .d8b.    #
#    88   88   d8P Y8b d8P Y8b 88 88    88 88  8b d8P Y8b   #
#    88   88   8888888 8888888 88 88    88 88  88 8888888   #
#    88   88   Y8b.    Y8b.    88 88    88 88  88 Y8b.      #
#  888888 88    ºY888P  ºY888P 88 88    88 88  88  ºY888P   #
#                           (c) 2015-2024 I Feel Fine, Inc. #
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
# Dockerfile
# Github Repo: <ifeelfine/ghost-init>
# -------------
# Description: 
# Defines a container to be used as the init container for our
# Ghost.org self-hosted blog. This container will instantiate
# the content directory and install any required plugins.
# -------------
# Requirements:
# - Docker/Podman
# - Container Registry account
# - machine capable of multi-architecture build

# Start from a small nodejs image
FROM node:18-slim

# Build Arguments and Image Labels
ARG INIT_SCRIPT_URL=https://r2.ifeelfine.ca/ghost-init
ARG GHOST_DIR=/var/lib/ghost/content/
ARG NODE_USER=1000:1000

LABEL org.opencontainers.image.created="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
LABEL org.opencontainers.image.description="A Node.js that instantiates the Ghost environment"
LABEL org.opencontainers.image.licenses="GPL2"
LABEL org.opencontainers.image.source="https://github.com/IFeelFine/ghost-init"
LABEL org.opencontainers.image.title="Internal Ghost Environment Initialization"
LABEL org.opencontainers.image.vendor="I Feel Fine"
LABEL org.opencontainers.image.version="v0.1.1"

ADD ${INIT_SCRIPT_URL} /ghost-init

RUN    chmod +x /ghost-init \
    && mkdir -p ${GHOST_DIR} \
    && chown ${NODE_USER} ${GHOST_DIR}

WORKDIR /opt/node

ENTRYPOINT [ "/ghost-init" ]