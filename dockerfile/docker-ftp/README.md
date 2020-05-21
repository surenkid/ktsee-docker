vsftpd with alpine, change gid and uid to 82 for php, some environment can be set:

- PASSWORD: ftp password, if none, you can find a random password in docker output log
- PASV_ENABLE: pasv mode state, you can set YES or NO
- PASV_ADDRESS: pasv address, you can set host ip or domain(see below)
- PASV_ADDR_RESOLVE: if PASV_ADDRESS set host domain, need change to YES
- PASV_MIN_PORT: pasv min port
- PASV_MAX_PORT: pasv max port
- IGNORE_PERMISSION: ignore ftp home folder permission setting, if set YES, it will not execute chown for ftp home folder

docker-stack.yaml example:

```
version: "3"

services:
  ftp:
    image: surenkid/ktsee-ftp:latest
    volumes:
      - "ftp_www:/home"
    ports:
      - "21:21"
      - "21100-21110:21100-21110"
    environment:
      PASSWORD: ${pass}
      PASV_ENABLE: "YES"
      PASV_ADDRESS: ${ip}
      PASV_ADDR_RESOLVE: "NO"
      PASV_MIN_PORT: 21100
      PASV_MAX_PORT: 21110
      IGNORE_PERMISSION: "YES"
    deploy: 
      replicas: 1
      restart_policy:
        condition: on-failure
      placement:
        constraints: [node.role == manager]

volumes:
  ftp_www:
    driver: local
    driver_opts:
      type: nfs
      o: addr=${nfs},vers=4,soft,rw
      device: ":/volumes/web"
```
