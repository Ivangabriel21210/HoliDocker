# Usa la imagen base de Ubuntu 20.04
FROM ubuntu:20.04

# Establece la variable de entorno DEBIAN_FRONTEND a noninteractive para evitar prompts durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza el sistema e instala las dependencias necesarias
RUN apt-get update -y && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    wget \
    software-properties-common \
    sudo

# Agrega el repositorio oficial de Docker e instala Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update -y && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Habilita el modo Docker-in-Docker (DinD) con privilegios
RUN mkdir -p /var/lib/docker

# Descarga el binario de Gotty y lo coloca en /usr/local/bin
RUN wget -P /usr/local/bin/ https://raw.githubusercontent.com/Ivangabriel21210/HolicraftDocker/refs/heads/main/gotty && \
    chmod +x /usr/local/bin/gotty

# Expone el puerto 8080 para Gotty y el puerto 2375 para el daemon de Docker
EXPOSE 8080 2375

# Arranca el Docker daemon en segundo plano y ejecuta Gotty
CMD ["sh", "-c", "dockerd --storage-driver=vfs & sleep 5 && gotty -w --port 8080 /bin/bash"]
