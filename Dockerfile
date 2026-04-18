FROM python:3.11-slim-bookworm

LABEL maintainer="Bjorn Docker"
LABEL description="Bjorn network scanner - headless/web-only mode"

WORKDIR /app

# Copy requirements first for better layer caching
COPY requirements-docker.txt ./

# Install build tools + runtime deps, compile Python packages, then drop build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    nmap \
    iproute2 \
    iputils-ping \
    net-tools \
    arp-scan \
    wireless-tools \
    procps \
    && pip install --no-cache-dir -r requirements-docker.txt \
    && apt-get purge -y gcc python3-dev \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Copy source
COPY . .

# Headless mode: disables e-paper hardware, uses NullEPDHelper
ENV BJORN_HEADLESS=1

# Web interface port
EXPOSE 8000

CMD ["python", "Bjorn.py"]
