Forked from [fauria/docker-vsftpd](https://github.com/fauria/docker-vsftpd), change gid and uid to 82 for php.

docker-stack.yaml example:

```
version: "3"

services:
  ftp:
    image: surenkid/docker-vsftpd:latest
    volumes:
      - "ftp_www:/home/vsftpd"
    ports:
      - "21:21"
      - "21100-21110:21100-21110"
    environment:
      PASV_ADDRESS: ${host}
      FTP_USER: ${user}
      FTP_PASS: ${pass}
      PASV_MIN_PORT: 21100
      PASV_MAX_PORT: 21110
      PASV_ADDR_RESOLVE: "YES"
      FILE_OPEN_MODE: 0777
      LOCAL_UMASK: 777
      LOG_STDOUT: "YES"
    deploy: 
      replicas: 1
      restart_policy:
        condition: on-failure
      placement:
        constraints: [node.role == worker]

volumes:
  ftp_www:
    driver: local
    driver_opts:
      type: nfs
      o: addr=${nfs},vers=4,soft,rw
      device: ":/volumes/web"
```
