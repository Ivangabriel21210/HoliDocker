#!/data/data/com.termux/files/usr/bin/bash

# ========== CONFIG ==========
API_URL="http://kelvin.conexioan.com:8080/verificar"
TOKEN_FILE=".acceso_autorizado"
BUG_FILE="claro.com.do.txt"
verde='\033[0;32m'
rojo='\033[0;31m'
normal='\033[0m'

# ========== FUNCIONES ==========

validar_clave() {
  echo -e "${verde}[*] Validando clave en servidor...${normal}"
  RESPUESTA=$(curl -s -X POST -H "Content-Type: application/json" -d "{\"id\":\"$CLAVE\"}" "$API_URL")
  STATUS=$(echo "$RESPUESTA" | grep -o '"status":"[^"]*"' | cut -d':' -f2 | tr -d '"')

  if [ "$STATUS" = "permitido" ]; then
    echo -e "${verde}[✔] Clave válida. Guardando autorización...${normal}"
    echo "$CLAVE" > "$TOKEN_FILE"
  else
    echo -e "${rojo}⛔ Clave inválida. Acceso denegado.${normal}"
    exit 1
  fi
}

instalar_dependencias() {
  for pkg in git python; do
    if ! command -v $pkg >/dev/null 2>&1; then
      echo -e "${verde}[*] Instalando $pkg...${normal}"
      pkg install -y $pkg
    fi
  done

  if ! python3 -c "import bugscanner" 2>/dev/null; then
    if [ ! -d "bugscanner" ]; then
      git clone https://github.com/aztecrabbit/bugscanner
    fi
    cd bugscanner
    python3 -m pip install -r requirements.txt
    python3 -m pip install setuptools requests loguru --break-system-packages
    python3 setup.py install
    cd ..
  else
    echo -e "${verde}[✔] bugscanner ya instalado.${normal}"
  fi
}

descargar_bugfile() {
  if [ ! -f "$BUG_FILE" ]; then
    echo -e "${verde}[*] Descargando lista de hosts...${normal}"
    curl -s -o "$BUG_FILE" "https://raw.githubusercontent.com/Ivangabriel21210/HoliDocker/main/claro.com.do.txt"
  else
    echo -e "${verde}[✔] Lista de hosts ya descargada.${normal}"
  fi
}

ejecutar_escaneo_y_curl() {
  echo -e "${verde}📡 Escaneando puerto 443...${normal}"
  bugscanner "$BUG_FILE" --port 443

  echo -e "${verde}📡 Escaneando puerto 80...${normal}"
  bugscanner "$BUG_FILE" --port 80

  echo -e "${verde}🌐 Conectando a miclaroempresas.claro.com.do (https)...${normal}"
  curl -s -I https://miclaroempresas.claro.com.do

  echo -e "${verde}🌐 Conectando a miclaroempresas.claro.com.do (http)...${normal}"
  curl -s -I http://miclaroempresas.claro.com.do
}

# ========== EJECUCIÓN ==========

if [ "$1" != "-cl" ] || [ -z "$2" ]; then
  echo -e "${rojo}⛔ Uso correcto: ./bug.sh -cl TUCLAVE${normal}"
  exit 1
fi

CLAVE="$2"

# Verificar si ya tiene permiso local
if [ ! -f "$TOKEN_FILE" ]; then
  validar_clave
else
  echo -e "${verde}[✔] Acceso previamente autorizado. Continuando...${normal}"
fi

instalar_dependencias
descargar_bugfile

# ========== LOOP PRINCIPAL ==========
while true; do
  ejecutar_escaneo_y_curl
  echo -e "${verde}[⏳] Esperando 10 minutos para siguiente ciclo...${normal}"
  sleep 600
done
