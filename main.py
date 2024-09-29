from os import system

system("wget https://raw.githubusercontent.com/Ivangabriel21210/HolicraftDocker/refs/heads/main/gotty")
system("chmod +x gotty")
system("./gotty -w --port 8080 /bin/bash")
