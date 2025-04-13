In Docker

nginx:latest --> debian related images
- apt-get update -y && apt-get install procps -y            ## for `ps -ef`
- apt-get update -y && apt install curl -y                  ## for `curl localhost:80`
- apt-get update -y && apt install net-tools -y             ## for `netstat -tunlap`
- apt-get update -y && apt install telnet -y                ## for `telnet localhost 80`


alipine:latest -->
- apk add --no-cache curl


















