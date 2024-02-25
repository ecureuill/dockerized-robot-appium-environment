## This is an modified version of official robotframework-browser Dockerfile (https://github.com/MarketSquare/robotframework-browser/blob/main/docker/Dockerfile.latest_release)
FROM mcr.microsoft.com/playwright:v1.30.0-focal

USER root
RUN apt-get update
RUN apt-get install -y python3 python3-pip && rm -rf /var/lib/apt/lists/*

ENV PATH="/home/pwuser/.local/bin:${PATH}"
ENV NODE_PATH=/usr/lib/node_modules

USER pwuser
RUN pip3 install --no-cache-dir --upgrade pip wheel
RUN pip3 --version
RUN pip3 install --no-cache-dir --user --upgrade robotframework 
RUN pip3 install --no-cache-dir --user --upgrade  robotframework-appiumlibrary

WORKDIR ./tests