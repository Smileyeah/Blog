# 使用Alpine-Linux做基础镜像的aarch64版本镜像
制作的依赖Microsoft.EntityFrameworkCore.Sqlite可运行镜像。dotnet版本3.1.11

## 基础镜像地址
```
https://hub.docker.com/_/microsoft-dotaarch64net-aspnet?tab=description
```

## 拉取镜像
```
docker pull mcr.microsoft.com/dotnet/aspnet:3.1.11-alpine3.12
```

## Dockerfile
```
FROM mcr.microsoft.com/dotnet/aspnet:3.1.11-alpine3.12
COPY app /opt/app
RUN  apk add --no-cache libc6-compat
EXPOSE 5001
WORKDIR /opt/app/
CMD /bin/sh  /opt/app/runApp.sh
```

## 遇到的问题

1、libe_sqlite3.so的依赖缺失，ldd查看库依赖。
```
 ldd libe_sqlite3.so
        /lib/ld-musl-aarch64.so.1 (0xffffa9187000)
        libc.so.6 => /lib/ld-musl-aarch64.so.1 (0xffffa9187000)
Error loading shared library ld-linux-aarch64.so.1: No such file or directory (needed by libe_sqlite3.so)
Error relocating libe_sqlite3.so: __memcpy_chk: symbol not found
Error relocating libe_sqlite3.so: __memset_chk: symbol not found
```
https://pkgs.alpinelinux.org/contents?file=ld-linux-*&path=&name=&branch=edge&repo=main

### 解决方法：apk add --no-cache libc6-compat

2、运行时报错段错误：Segmentation fault (core dumped)，对崩溃产生的core文件进行gdb解析得到：
```
Thread 1 (LWP 52):
#0  0x000000000000e2b0 in ?? ()
#1  0x0000ffff7d6fa108 in unixOpen () from /opt/ganwei/IoTCenter/bin/runtimes/linux-arm64/native/libe_sqlite3.so
#2  0x0000ffff7d6a334c in sqlite3OsOpen () from /opt/ganwei/IoTCenter/bin/runtimes/linux-arm64/native/libe_sqlite3.so
#3  0x0000ffff7d6b2a94 in sqlite3JournalOpen () from /opt/ganwei/IoTCenter/bin/runtimes/linux-arm64/native/libe_sqlite3.so
```

在libe_sqlite3.so的源码https://github.com/ericsink/cb地址找到issue。判断为CPU架构不匹配。
### 解决方法：下载源码重新生成一个新的依赖库.
