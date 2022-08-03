# syntax=docker/dockerfile:1

FROM python:alpine

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH" PIP_NO_CACHE_DIR=off

COPY requirements.txt .

RUN apk add gcc musl-dev build-base linux-headers libffi-dev openssl-dev git avahi curl docker openrc && \
    pip install --upgrade pip wheel && \
    pip install -r requirements.txt && \
    apk del gcc musl-dev build-base linux-headers libffi-dev openssl-dev git curl && \
    rm -rf /root/.cache 

RUN rc-update add docker boot

WORKDIR /app

COPY . .

ENTRYPOINT ["/opt/venv/bin/python3", "sb_remote.py"]
