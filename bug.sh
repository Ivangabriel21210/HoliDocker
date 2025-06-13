#!/data/data/com.termux/files/usr/bin/bash

# Colores
verde='\033[0;32m'
rojo='\033[0;31m'
normal='\033[0m'

# Código secreto
CODIGO_CORRECTO="2121021"

# Verificar código
if [ "$1" != "-cl" ] || [ "$2" != "$CODIGO_CORRECTO" ]; then
    echo -e "${rojo}⛔ Acceso denegado. Ejecuta: ./bug.sh -cl 2121021${normal}"
    exit 1
fi

clear
echo -e "${verde}╔══════════════════════════════════════╗"
echo -e "║   ACCESO CONCEDIDO - MÉTODO $CODIGO_CORRECTO     ║"
echo -e "╚══════════════════════════════════════╝${normal}"

# Dependencias
[ ! -x "$(command -v git)" ] && echo -e "${verde}[*] Instalando git...${normal}" && pkg install -y git
[ ! -x "$(command -v python3)" ] && echo -e "${verde}[*] Instalando python3...${normal}" && pkg install -y python3
[ ! -x "$(command -v curl)" ] && echo -e "${verde}[*] Instalando curl...${normal}" && pkg install -y curl

# Instalar bugscanner si no está
if ! command -v bugscanner &> /dev/null; then
    echo -e "${verde}[*] Instalando bugscanner...${normal}"
    python3 -m pip install --upgrade pip
    python3 -m pip install bugscanner
else
    echo -e "${verde}[✔] bugscanner ya está instalado.${normal}"
fi

# Descargar archivo si no existe
if [ ! -f claro.com.do.txt ]; then
    echo -e "${verde}[*] Descargando claro.com.do.txt...${normal}"
    curl -s -o claro.com.do.txt https://raw.githubusercontent.com/Ivangabriel21210/HoliDocker/main/claro.com.do.txt
else
    echo -e "${verde}[✔] claro.com.do.txt ya está presente.${normal}"
fi

# Ejecutar escaneos (con salida oculta)
echo -e "${verde}[*] Escaneando puerto 443...${normal}"
bugscanner claro.com.do.txt --port 443 > /dev/null 2>&1

echo -e "${verde}[*] Escaneando puerto 80...${normal}"
bugscanner claro.com.do.txt --port 80 > /dev/null 2>&1

# CURL
echo -e "${verde}[*] Ejecutando curl HTTPS...${normal}"
curl -s -I https://miclaroempresas.claro.com.do | head -n 5

echo -e "${verde}[*] Ejecutando curl HTTP...${normal}"
curl -s -I http://miclaroempresas.claro.com.do | head -n 5

# Final
echo -e "${verde}✅ Listo. Abre Net Analyzer o haz Speedtest para ver si tienes internet FREE.${normal}"
