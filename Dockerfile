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
ARG NODE_VERSION=20
FROM node:${NODE_VERSION}-slim

# Build Arguments
ARG GHOST_DIR=/var/lib/ghost/content/
ARG NODE_USER=1000:1000

# Metadata
LABEL org.opencontainers.image.created="$(date +'%Y-%m-%dT%H:%M:%S.%6N-%Z')" \
      org.opencontainers.image.description="A Node.js based container that instantiates our Ghost CMS environment" \
      org.opencontainers.image.licenses="GPL2" \
      org.opencontainers.image.source="https://github.com/IFeelFine/ghost-init" \
      org.opencontainers.image.title="Internal Ghost Environment Initialization" \
      org.opencontainers.image.vendor="I Feel Fine" \
      org.opencontainers.image.version="v0.4.0"

# Install packages and update permissions
RUN  apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    gettext \
    curl \
    ca-certificates \
    jq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && mkdir -p ${GHOST_DIR} \
  && chown ${NODE_USER} ${GHOST_DIR}

WORKDIR /opt/node