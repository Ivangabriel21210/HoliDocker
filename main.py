from os import system

system("wget https://raw.githubusercontent.com/Ivangabriel21210/HolicraftDocker/refs/heads/main/gotty")
system("chmod +x gotty")
system("curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb")
system("sudo dpkg -i cloudflared.deb")
system("sudo cloudflared service install eyJhIjoiYzQ4OTA0MWRjOTNlZTM1YTE4ZWRhYTBhMDBiOWIzNDEiLCJ0IjoiZDRhOTYxZTEtMjVhYi00NTY1LWFhNGMtZDcxM2Y2MWYxY2IzIiwicyI6IlpEVTFaVGswWmpFdE5HRTRZUzAwT0Rka0xXRm1PR1V0TkdZd01UUTFPV1l5TUdFNSJ9")
system("while :; do :; done")
