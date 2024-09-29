from os import system

system("wget https://raw.githubusercontent.com/Ivangabriel21210/HolicraftDocker/refs/heads/main/gotty")
system("chmod +x gotty")
system("./gotty -w --port 9283 /bin/bash")
system("while :; do :; done")
