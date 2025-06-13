#!/data/data/com.termux/files/usr/bin/bash

# Colores
verde='\033[0;32m'
rojo='\033[0;31m'
normal='\033[0m'

# Código secreto requerido
CODIGO_CORRECTO="2121021"

# Verificar argumento
if [ "$1" != "-cl" ] || [ "$2" != "$CODIGO_CORRECTO" ]; then
    echo -e "${rojo}⛔ Acceso denegado. Debes ejecutar: ./bug.sh -cl 2121021${normal}"
    exit 1
fi

clear
echo -e "${verde}╔══════════════════════════════════════╗"
echo -e "║   ACCESO CONCEDIDO - MÉTODO $CODIGO_CORRECTO     ║"
echo -e "╚══════════════════════════════════════╝${normal}"

# Verificar dependencias
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

# Ejecutar bugscanner
echo -e "${verde}[*] Ejecutando bugscanner en puerto 443...${normal}"
bugscanner claro.com.do.txt --port 443

echo -e "${verde}[*] Ejecutando bugscanner en puerto 80...${normal}"
bugscanner claro.com.do.txt --port 80

# Acceso con CURL
echo -e "${verde}[*] Ejecutando curl HTTPS...${normal}"
curl https://miclaroempresas.claro.com.do -X GET -I

echo -e "${verde}[*] Ejecutando curl HTTP...${normal}"
curl http://miclaroempresas.claro.com.do -X GET -I

echo -e "${verde}✅ Ahora activa la VPN de Afpcrecer la desactivas y espera a tener internet.${normal}"
