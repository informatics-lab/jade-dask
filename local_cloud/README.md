```
docker build -t worker .
docker run -e MY_IP=$(dig +short myip.opendns.com @resolver1.opendns.com) -e SCD_ADDR=<SCheduler_IP> -p 8777:8777 -p 8778:8778 -p 8779:8779 worker
```