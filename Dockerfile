# Copyright (c) 2016-2024 Jes Shaw <jesshaw@126.com>

# Building an online documentation image based on mkdocs-material 
# with support for PLANTUML and PDF generation.

FROM python:3.11-slim-bullseye

# build args
ARG PLATNUML_URL=https://github.com/plantuml/plantuml/releases/download/v1.2024.3/plantuml-mit-1.2024.3.jar
ARG MKDOCS_MATERIAL_BRANCH_VERSION=9.5.15

# Environment variables
ENV TZ=Asia/Shanghai
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Set build directory
WORKDIR /tmp

# Perform build and cleanup artifacts and caches
RUN apt-get update && \
    apt-get install -y git curl default-jre fonts-noto-cjk graphviz && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L ${PLATNUML_URL} > /opt/plantuml.jar && \
    git clone --branch ${MKDOCS_MATERIAL_BRANCH_VERSION} https://github.com/squidfunk/mkdocs-material.git

# Copy files necessary for build
COPY bin/plantuml /usr/local/bin/plantuml

RUN chmod +x /usr/local/bin/plantuml && \
    pip install -e mkdocs-material && \
    pip install plantuml-markdown

# Set working directory
WORKDIR /docs

# Expose MkDocs development server port
EXPOSE 8000

# ENTRYPOINT ["mkdocs"]
# CMD ["serve", "--dev-addr=0.0.0.0:8000"]
