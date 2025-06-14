#!/data/data/com.termux/files/usr/bin/bash

verde='\033[0;32m'
rojo='\033[0;31m'
normal='\033[0m'
CODIGO="2121021"

# Verificar código secreto
if [ "$1" != "-cl" ] || [ "$2" != "$CODIGO" ]; then
  echo -e "${rojo}⛔ Código incorrecto. Usa: ./bug.sh -cl $CODIGO${normal}"
  exit 1
fi

clear
echo -e "${verde}╔══════════════════════════════════════╗"
echo -e "║ ACCESO CONCEDIDO - MÉTODO $CODIGO      ║"
echo -e "╚══════════════════════════════════════╝${normal}"

# Instalar dependencias necesarias
pkg update -y
pkg install -y git python3 curl

# Instalar bugscanner si no está
if [ ! -d "bugscanner" ]; then
  echo -e "${verde}[*] Clonando bugscanner...${normal}"
  git clone https://github.com/aztecrabbit/bugscanner
  cd bugscanner
  echo -e "${verde}[*] Instalando dependencias de bugscanner...${normal}"
  python3 -m pip install -r requirements.txt
  python3 -m pip install setuptools
  python3 -m pip install loguru --break-system-packages
  python3 -m pip install requests --break-system-packages
  python3 setup.py install
  cd ..
else
  echo -e "${verde}[✔] bugscanner ya está instalado.${normal}"
fi

# Descargar subdominios solo si no existe
if [ ! -f claro.com.do.txt ]; then
  echo -e "${verde}[*] Descargando claro.com.do.txt...${normal}"
  curl -s -o claro.com.do.txt https://raw.githubusercontent.com/Ivangabriel21210/HoliDocker/main/claro.com.do.txt
else
  echo -e "${verde}[✔] claro.com.do.txt ya está presente.${normal}"
fi

# Escaneo
echo -e "${verde}[*] Escaneando puerto 443...${normal}"
bugscanner claro.com.do.txt --port 443

echo -e "${verde}[*] Escaneando puerto 80...${normal}"
bugscanner claro.com.do.txt --port 80

# Prueba de conexión directa
echo -e "${verde}[*] Verificando host directo...${normal}"
curl -I https://miclaroempresas.claro.com.do | head -n 5
curl -I http://miclaroempresas.claro.com.do | head -n 5

echo -e "${verde}✅ Listo. ¡Ahora prueba tu internet gratis, bro!${normal}"
