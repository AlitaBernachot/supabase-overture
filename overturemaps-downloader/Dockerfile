FROM python:3.11-slim

RUN apt update \
    && apt install -y \
        make

WORKDIR /code

# -------------------------------
# overturemaps-py
# -------------------------------
RUN pip install --upgrade pip
RUN pip install overturemaps fastapi uvicorn

# -------------------------------
# Homebrew
# -------------------------------

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    unzip \
    libgdal-dev \
    software-properties-common

RUN useradd -m -s /bin/bash linuxbrew && \
    echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
    
USER linuxbrew

# RUN curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash && \
#     echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile && \
#     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
#     brew update

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

USER root
ENV PATH="/home/linuxbrew/.linuxbrew/bin:${PATH}"

# -------------------------------
# GDAL
# -------------------------------
USER linuxbrew
RUN brew install gdal

EXPOSE 8080

CMD exec uvicorn app.server:app --host 0.0.0.0 --port 8080
