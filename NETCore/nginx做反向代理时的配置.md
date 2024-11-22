## nginx做反向代理时的配置

### 转发http
```
http {
  map $http_connection $connection_upgrade {
    "~*Upgrade" $http_connection;
    default keep-alive;
  }

  upstream myserver {
    server 10.0.0.17:31527;
  }

  server {
    listen 80;
    server_name 10.0.0.11;

    location /hubroute {
      proxy_pass http://myserver;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_cache off;
      proxy_http_version 1.1;
      proxy_buffering off;
      proxy_read_timeout 100s;
      proxy_set_header Host $host:$server_port;
      proxy_set_header X-Real-lP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
    }
  }
}

```

**此配置可转发signalR，且301跳转时正确跳转到非80代理端口**

### 转发tcp端口

在nginx的总配置文件nginx.conf增加stream类型的代理：
```
# /etc/nginx/conf.d/stream.conf

# proxy mariadb
stream {
    upstream mariadb-backend {
        server 10.0.0.51:3306;
        server 10.0.0.52:3306;
    }
    server {
        listen 3306;
        proxy_pass mariadb-backend;
    }
}

```

```
upstream gwc-lmt0ej5mntn2-3d {
    server 10.0.0.17:30803;
}
server {
    keepalive_requests 120;
    listen       5789;
    server_name  10.0.0.6;
    proxy_pass  gwc-lmt0ej5mntn2-3d;
}

```
