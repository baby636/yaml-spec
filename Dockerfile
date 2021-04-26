FROM ubuntu:20.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
        build-essential \
        cpanminus \
        default-jre \
        docbook-xsl \
        ghostscript \
        git \
        jekyll \
        libexpat1-dev \
        libffi7 \
        libffi-dev \
        libxml2-dev \
        nodejs \
        npm \
        silversearcher-ag \
        tig \
        tmux \
        unzip \
        vim \
        xsltproc \
 && true

RUN mkdir /node_modules \
 && npm install -g coffeescript \
 && npm install \
        ingy-prelude \
        turndown \
        turndown-plugin-gfm \
 && cpanm install -n \
        XML::Parser \
        YAML \
 && true

COPY jekyll/Gemfile /

RUN gem install -g /Gemfile
